import requests
import datetime
import boto3
import logging


logging.basicConfig(level=logging.INFO)
def get_ghdata(date):
    url = "https://data.gharchive.org/{}-15.json.gz"
    formatted_url = url.format(date)

    logging.info(f"downloading data from: {formatted_url}")
    data = requests.get(formatted_url)
    logging.info("Download complete!")

    return data.content

def upload_to_s3(content, bucket_name, key):
    logging.info(f"Uploading to s3({bucket_name})")
    year = datetime.date.today().year
    month = datetime.date.today().month
    file_key = "{}/{}/{}".format(year, month, key)

    logging.info(f"Uploading to: {file_key}")
    s3_client = boto3.client("s3")
    s3_client.put_object(Body=content, Bucket=bucket_name, Key=file_key)
    logging.info("Upload complete!")

    

if __name__ == "__main__":
    today = datetime.date.today()
    previous_day = today - datetime.timedelta(days=1)
    logging.info(f"Extracting data for the following date: {previous_day}")
    file_name = f"{previous_day}-15.json.gz"
    content = get_ghdata(previous_day)
    upload_to_s3(content=content, bucket_name="mide-ecs-batch-job", key=file_name)
    logging.info(f"completed batch for {today} ")
    