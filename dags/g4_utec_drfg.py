from airflow.decorators import dag, task
from pendulum import timezone
from scripts.azure_upload import upload_to_adls
from scripts.helpers import add_date_suffix
from datetime import datetime, timedelta
from scripts.mysql_extractor import leer_datos_mysql
from scripts.transform import transform_data
from scripts.mongo_extractor import leer_datos_mongo
import logging

LOCAL_FILE_PATH = "/opt/airflow/data/sample.txt"
CONTAINER_NAME = "datalake"

BLOB_NAME = "raw/airflow/G4/transactions_data.csv"
CSV_LOCAL_FILE_PATH = "/opt/airflow/data/transactions_data.csv"

MONGO_BLOB_NAME = "raw/airflow/G4/accounts_data.csv"
MONGO_CSV_PATH = "/opt/airflow/data/accounts_data.csv"

WASB_CONN_ID = "utec_blob_storage"

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}


@dag(
    dag_id="g4_utec_drfg",
    description="Uploads a local file to Azure Blob Storage with a date suffix.",
    default_args=default_args,
    start_date=datetime(2025, 1, 1, tzinfo=timezone("America/Bogota")),
    schedule="0 12 * * 1",  # Runs every monday at 12:00 local time (GMT-5)
    catchup=False,
    tags=["azure", "blob", "upload", "mysql"],
)
def upload_dag():

  @task
  def extraer_mysql():
    try:
      df = leer_datos_mysql()

      logging.info(f"Data extracted correctamente. Shape: {df.shape}")
      return df
    except Exception as e:
      logging.error(f"Error in data extraction: {e}")
      raise

  @task
  def extraer_mongo():
    try:
      # Extract all accounts from MongoDB
      df = leer_datos_mongo()
      # Alternative: Extract only active accounts
      # df = leer_cuentas_activas()

      logging.info(f"MongoDB data extracted correctamente. Shape: {df.shape}")
      logging.info(f"Columns: {list(df.columns)}")
      return df
    except Exception as e:
      logging.error(f"Error in MongoDB data extraction: {e}")
      raise

  @task
  def transform_mysql(df):
    try:
      df_transformed = transform_data(df)
      df_transformed.to_csv(CSV_LOCAL_FILE_PATH, index=False)
      return df_transformed
    except Exception as e:
      logging.error(f"Error in data transformation: {e}")
      raise

  @task
  def transform_mongo(df):
    try:
      df.to_csv(MONGO_CSV_PATH, index=False)
      logging.info(f"MongoDB data saved to {MONGO_CSV_PATH}")
      return df
    except Exception as e:
      logging.error(f"Error processing MongoDB data: {e}")
      raise

  @task
  def subir_mysql_a_azure(transformation_result):
    try:
      new_blob_name = add_date_suffix(BLOB_NAME)
      upload_to_adls(
          local_file_path=CSV_LOCAL_FILE_PATH,
          container_name=CONTAINER_NAME,
          blob_name=new_blob_name,
          wasb_conn_id=WASB_CONN_ID
      )

      logging.info(f"Se subió el archivo: {new_blob_name}")
      logging.info(f"Shape del dataframe: {transformation_result.shape}")

      return {
          "blob_name": new_blob_name,
          "upload_status": "success"
      }

    except Exception as e:
      logging.error(f"Error uploading to Azure: {e}")
      raise

  @task
  def subir_mongo_a_azure(transformation_result):
    try:
      new_blob_name = add_date_suffix(MONGO_BLOB_NAME)
      upload_to_adls(
          local_file_path=MONGO_CSV_PATH,
          container_name=CONTAINER_NAME,
          blob_name=new_blob_name,
          wasb_conn_id=WASB_CONN_ID
      )

      logging.info(f"MongoDB file uploaded: {new_blob_name}")
      logging.info(f"Shape del dataframe: {transformation_result.shape}")

      return {
          "blob_name": new_blob_name,
          "upload_status": "success",
          "source": "mongodb"
      }

    except Exception as e:
      logging.error(f"Error uploading MongoDB data to Azure: {e}")
      raise

  # Task execution flow
  # MySQL pipeline
  mysql_extraction = extraer_mysql()
  mysql_transformation = transform_mysql(mysql_extraction)
  mysql_upload = subir_mysql_a_azure(mysql_transformation)

  # MongoDB pipeline
  mongo_extraction = extraer_mongo()
  mongo_transformation = transform_mongo(mongo_extraction)
  mongo_upload = subir_mongo_a_azure(mongo_transformation)


dag = upload_dag()
