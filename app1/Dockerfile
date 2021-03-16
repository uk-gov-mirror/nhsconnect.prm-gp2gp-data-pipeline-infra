FROM python:3.9-alpine

COPY . /wordcount

RUN cd /wordcount && python setup.py install

ENTRYPOINT ["python", "-m", "wordcount.main"]