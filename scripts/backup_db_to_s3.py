import boto3
import os
from datetime import datetime

s3 = boto3.client('s3')
bucket_name = 'clubhub-b'
db_path = '/application/database/database.db'

def backup_database():
    backup_path = f"backups/database_{datetime.now().strftime('%Y%m%d%H%M%S')}.db"
    s3.upload_file(db_path, bucket_name, backup_path)
    print(f"Database backup uploaded to {backup_path}")

if __name__ == "__main__":
    backup_database()