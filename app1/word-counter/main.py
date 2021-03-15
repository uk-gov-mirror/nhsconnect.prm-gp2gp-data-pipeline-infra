#!/usr/bin/env/python
import json

import boto3
from botocore.client import Config


def main():
    s3 = boto3.resource('s3',
                        endpoint_url='http://localhost:9000',
                        aws_access_key_id='minio_user',
                        aws_secret_access_key='minio_pass',
                        config=Config(signature_version='s3v4'),
                        region_name='us-east-1')

    my_object = s3.Object('transfer', 'test-file-3')

    data = "hello world 1234"

    data1 = word_count(data)


    body = bytes(json.dumps(data1).encode('UTF-8'))

    my_object.put(Body=body, ContentType='text/plain')

    # my_second_data = my_object.get()['Body'].read().decode('utf-8')


def word_count(string):
    counts = dict()
    words = string.split()

    for word in words:
        if word in counts:
            counts[word] += 1
        else:
            counts[word] = 1

    return counts

if __name__ == "__main__":main()