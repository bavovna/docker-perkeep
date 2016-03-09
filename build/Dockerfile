FROM mkorenkov/go:latest

RUN apk add --update git \
                     sqlite-dev \
                     sqlite-libs
COPY ./src/camlistore /opt/camlistore
WORKDIR /opt/camlistore
ENV PATH=/usr/local/go/bin/:$PATH
VOLUME ["/opt/camlistore/bin"]
