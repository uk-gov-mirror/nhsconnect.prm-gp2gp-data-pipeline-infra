FROM python:3.9-alpine

ENV S3_INPUT_URL='http://127.0.0.1:9000/minio/transfer'
ENV S3_OUTPUT_URL='http://127.0.0.1:9000/minio/result'

COPY . /wordcount

RUN cd /wordcount && python setup.py install

ENTRYPOINT ["python", "-m", "wordcount.main"]