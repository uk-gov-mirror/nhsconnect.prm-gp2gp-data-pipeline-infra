import json
import logging
from os import environ

import boto3
from urllib.parse import urlparse

from wordcount.config import WordCountConfig
from wordcount.count import word_count

logger = logging.getLogger(__name__)


def main(config):
    logging.basicConfig(level=logging.INFO)
    s3 = boto3.resource('s3', endpoint_url=config.s3_endpoint_url)

    input_object = s3_object(s3, config.s3_input_url)
    output_object = s3_object(s3, config.s3_output_url)
    logger.info(f"input url is: {config.s3_input_url}" )
    logger.info(f"output url is: {config.s3_output_url_url}" )
    input_data = download_string(input_object)
    words = word_count(input_data)
    logger.info(words)
    upload_json_string(output_object, words)


def s3_object(s3, url_string):
    object_url = urlparse(url_string)
    s3_bucket = object_url.netloc
    s3_key = object_url.path.lstrip("/")
    return s3.Object(s3_bucket, s3_key)


def download_string(s3_obj):
    return s3_obj.get()['Body'].read().decode('utf-8')


def upload_json_string(s3_obj, string):
    body = bytes(json.dumps(string).encode('UTF-8'))
    s3_obj.put(Body=body, ContentType='application/json')


if __name__ == "__main__":
    main(config=WordCountConfig.from_environment_variables(environ))
