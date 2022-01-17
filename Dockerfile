FROM ubuntu:20.04

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y python3.8 python3-pip python-dev curl

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

RUN mkdir /root/.aws/

COPY credentials /root/.aws/credentials

COPY credentials /root/.aws/config

ENTRYPOINT [ "python3" ]

CMD [ "wsgi.py" ]
