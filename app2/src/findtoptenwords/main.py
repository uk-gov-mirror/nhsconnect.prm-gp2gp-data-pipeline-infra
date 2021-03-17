import json
import logging
from os import environ

import boto3

from urllib.parse import urlparse
from findtoptenwords.config import FindTopTenWords

logger = logging.getLogger(__name__)

def main(config):
    s3 = boto3.resource('s3', endpoint_url=config.s3_endpoint_url)

    input_object = s3_object(s3, config.s3_input_url)
    output_object = s3_object(s3, config.s3_output_url)

    input_json_data = download_string(input_object)
    top_ten_words = _find_top_ten_words(input_json_data)

    upload_json_string(output_object, top_ten_words)
    logger.info(json.dumps(top_ten_words))


def s3_object(s3, url_string):
    object_url = urlparse(url_string)
    s3_bucket = object_url.netloc
    s3_key = object_url.path.lstrip("/")
    return s3.Object(s3_bucket, s3_key)

def download_string(s3_obj):
    return s3_obj.get()['Body'].read().decode('utf-8')

def _find_top_ten_words(input_json):
    data = json.loads(input_json)
    my_list=[]
    for key, value in data.items():
        my_list.append([key,value])

    return my_list[0:10]

def upload_json_string(s3_obj, array):
    body = bytes(json.dumps(array).encode('UTF-8'))
    s3_obj.put(Body=body, ContentType='application/json')

if __name__ == "__main__":
    main(config=FindTopTenWords.from_environment_variables(environ))