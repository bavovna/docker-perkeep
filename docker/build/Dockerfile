FROM mkorenkov/go:latest

COPY ./issue811-master.diff /opt/issue811.diff
#RUN export CAMLISTORE_VERSION="tags/0.9" && \
RUN export CAMLISTORE_VERSION="ce8b329d1d62a4ff6ab87812f657914ae7625f6d" && \
    git clone https://camlistore.googlesource.com/camlistore /opt/camlistore && \
    cd /opt/camlistore && \
    git checkout $CAMLISTORE_VERSION && \
    git apply /opt/issue811.diff && \
    rm /opt/issue811.diff && \
    cd -
WORKDIR /opt/camlistore

VOLUME ["/opt/camlistore/bin"]
