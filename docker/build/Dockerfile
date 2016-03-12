FROM mkorenkov/go:latest

RUN git clone https://camlistore.googlesource.com/camlistore /opt/camlistore && cd /opt/camlistore && git checkout tags/0.9 && cd -
WORKDIR /opt/camlistore
ENV PATH=/usr/local/go/bin/:$PATH
VOLUME ["/opt/camlistore/bin"]
