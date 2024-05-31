import boto3
import os
from datetime import datetime
from sqlite3 import connect
from pathlib import Path

s3 = boto3.client('s3')
bucket_name = 'clubhub-b'

# Assuming the script is located two levels below the main project directory
project_directory = Path(__file__).resolve().parents[2]
db_path = project_directory / 'app' / 'application' / 'database' / 'database.db'
schema_path = project_directory / 'app' / 'application' / 'database' / 'schema.sql'
populate_path = project_directory / 'app' / 'application' / 'database' / 'populate.sql'

def initialize_database():
    """Initializes the database if it does not exist with schema and optional data."""
    db_path.parent.mkdir(parents=True, exist_ok=True)  # Ensure the database directory exists
    connection = connect(str(db_path))  # Connect to the database
    with open(schema_path, 'r') as schema_file:
        connection.executescript(schema_file.read())
    with open(populate_path, 'r') as populate_file:
        connection.executescript(populate_file.read())
    connection.commit()
    connection.close()

def backup_database():
    """Backs up the database to an S3 bucket."""
    if not db_path.exists():
        print("Database not found, initializing...")
        initialize_database()
    
    backup_path = f"backups/database_{datetime.now().strftime('%Y%m%d%H%M%S')}.db"
    s3.upload_file(str(db_path), bucket_name, backup_path)
    print(f"Database backup uploaded to {backup_path}")

if __name__ == "__main__":
    print("checking.....")
    backup_database()