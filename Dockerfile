# Docker image for squash-bokeh microservice
FROM python:3.6-slim
LABEL maintainer "afausti@lsst.org"
WORKDIR /opt
COPY . .

# needed to compile numpy
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y gcc

# set --default-timeout if you are annoyed by pypi.python.org time out errors (default is 15s)
RUN pip install --default-timeout=120 --no-cache-dir -r requirements.txt
EXPOSE 5006
# http://bokeh.pydata.org/en/latest/docs/user_guide/server.html#reverse-proxying-with-nginx-and-ssl
WORKDIR /opt/app
CMD bokeh serve --use-xheaders --allow-websocket-origin=$SQUASH_BOKEH_HOST \
    --allow-websocket-origin=$SQUASH_DASH_HOST $SQUASH_BOKEH_APPS 

