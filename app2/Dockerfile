FROM python:3.9-alpine

COPY . /findtoptenwords

RUN cd /findtoptenwords && python setup.py install

ENTRYPOINT ["python", "-m", "findtoptenwords.main"]