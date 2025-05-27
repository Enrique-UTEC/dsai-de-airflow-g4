from airflow.decorators import dag, task
from pendulum import timezone
from scripts.azure_upload import upload_to_adls
from scripts.helpers import add_date_suffix
from datetime import datetime, timedelta
from scripts.mysql_extractor import leer_datos_mysql
import logging

LOCAL_FILE_PATH = "/opt/airflow/data/sample.txt"
CONTAINER_NAME = "airflow"
BLOB_NAME = "raw/G0/banking_data.csv"
CSV_LOCAL_FILE_PATH = "/opt/airflow/data/banking_data.csv"
WASB_CONN_ID = "utec_blob_storage"

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}


@dag(
    dag_id="g0_atm",
    description="Uploads a local file to Azure Blob Storage with a date suffix.",
    default_args=default_args,
    start_date=datetime(2025, 1, 1, tzinfo=timezone("America/Bogota")),
    schedule="0 12 * * 1",  # Runs every monday at 12:00 local time (GMT-5)
    catchup=False,
    tags=["azure", "blob", "upload", "mysql"],
)
def upload_dag():

  @task
  def extraer():
    try:
      df = leer_datos_mysql()
      df.to_csv(CSV_LOCAL_FILE_PATH, index=False)

      logging.info(f"Data extracted successfully. Shape: {df.shape}")
      logging.info(f"Data saved to: {CSV_LOCAL_FILE_PATH}")

      return {
          "records_count": len(df),
          "file_path": CSV_LOCAL_FILE_PATH,
          "columns": list(df.columns)
      }
    except Exception as e:
      logging.error(f"Error in data extraction: {e}")
      raise

  @task
  def subir_a_azure(extraction_info):
    try:
      new_blob_name = add_date_suffix(BLOB_NAME)
      upload_to_adls(
          local_file_path=CSV_LOCAL_FILE_PATH,
          container_name=CONTAINER_NAME,
          blob_name=new_blob_name,
          wasb_conn_id=WASB_CONN_ID
      )

      logging.info(f"File uploaded successfully to: {new_blob_name}")
      logging.info(f"Records uploaded: {extraction_info['records_count']}")

      return {
          "blob_name": new_blob_name,
          "upload_status": "success",
          "records_uploaded": extraction_info['records_count']
      }

    except Exception as e:
      logging.error(f"Error uploading to Azure: {e}")
      raise

  extraction_result = extraer()
  upload_result = subir_a_azure(extraction_result)

dag = upload_dag()