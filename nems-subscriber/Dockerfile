FROM python:3.9-slim

WORKDIR /work

RUN pip install --upgrade pip

ADD requirements.txt ./
RUN pip install -r requirements.txt