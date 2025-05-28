import pandas as pd
import mysql.connector
from mysql.connector import Error
import logging
from typing import Dict, Any
import os

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class MySQLExtractor:
    def __init__(self):
        self.config = {
            'host': os.getenv('MYSQL_HOST'),
            'port': os.getenv('MYSQL_PORT'),
            'database': os.getenv('MYSQL_DATABASE'),
            'user': os.getenv('MYSQL_USER'),
            'password': os.getenv('MYSQL_PASSWORD'),
        }
        logger.info("MySQLExtractor initialized with configuration: %s", self.config)
    
    def get_connection(self):
        try:
            connection = mysql.connector.connect(**self.config)
            if connection.is_connected():
                logger.info("Successfully connected to MySQL database")
                return connection
        except Error as e:
            logger.error(f"Error connecting to MySQL: {e}")
            raise
    
    def execute_query(self, query: str) -> pd.DataFrame:
        connection = None
        try:
            connection = self.get_connection()
            df = pd.read_sql(query, connection)
            logger.info(f"Query executed successfully. Rows returned: {len(df)}")
            return df
        except Error as e:
            logger.error(f"Error executing query: {e}")
            raise
        finally:
            if connection and connection.is_connected():
                connection.close()
                logger.info("MySQL connection closed")
    
    def extract_banking_summary(self) -> pd.DataFrame:
        query = """
        SELECT 
            t.transaction_id,
            t.date as transaction_date,
            t.amount,
            t.transaction_type,
            a.account_id,
            a.account_type,
            a.currency,
            a.status as account_status,
            c.customer_id,
            c.full_name,
            c.nationality,
            b.branch_id,
            b.name as branch_name,
            b.city,
            b.country
        FROM transactions t
        JOIN accounts a ON t.account_id = a.account_id
        JOIN customers c ON a.customer_id = c.customer_id
        JOIN branches b ON t.branch_id = b.branch_id
        ORDER BY t.date DESC, t.transaction_id
        """
        return self.execute_query(query)


def leer_datos_mysql() -> pd.DataFrame:
    extractor = MySQLExtractor()
    
    try:
        logger.info("Extracting banking data from MySQL")
        return extractor.extract_banking_summary()
            
    except Exception as e:
        logger.error(f"Error in data extraction: {e}")
        raise