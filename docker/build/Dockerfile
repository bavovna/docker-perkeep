FROM mkorenkov/go:latest

RUN export CAMLISTORE_VERSION="0.9" && \
    git clone https://camlistore.googlesource.com/camlistore /opt/camlistore && \
    cd /opt/camlistore && \
    git checkout "tags/$CAMLISTORE_VERSION" && \ 
    cd -
WORKDIR /opt/camlistore

VOLUME ["/opt/camlistore/bin"]
