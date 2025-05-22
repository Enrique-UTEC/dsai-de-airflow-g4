from airflow.decorators import dag, task
from datetime import datetime
from scripts.helpers import transformar_datos

INPUT_FILE_PATH = "/opt/airflow/data/input.csv"
OUTPUT_FILE_PATH = "/opt/airflow/data/output.csv"

@dag(
    dag_id='08_dag_etl_pro',
    start_date=datetime(2023, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["transformación", "ejemplo"]
)
def dag_transformacion():
    
    @task
    def task_transform():
        transformar_datos(input_file_path=INPUT_FILE_PATH, output_file_path=OUTPUT_FILE_PATH)

    task_transform()
dag = dag_transformacion()
