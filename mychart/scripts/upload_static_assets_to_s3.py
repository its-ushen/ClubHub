import boto3
import os

s3 = boto3.client('s3')
bucket_name = 'clubhub-b'
static_assets_path = 'app/application/static'

def upload_static_assets():
    for root, dirs, files in os.walk(static_assets_path):
        for file in files:
            file_path = os.path.join(root, file)
            s3_path = os.path.relpath(file_path, static_assets_path)
            s3.upload_file(file_path, bucket_name, s3_path)
            print(f"Uploaded {file_path} to {s3_path}")

if __name__ == "__main__":
    upload_static_assets()