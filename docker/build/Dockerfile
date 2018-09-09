FROM mkorenkov/go:latest

ENV GOPATH="/srv/go"
RUN export CAMLISTORE_VERSION="ad6dae391e62c3689d68e27e91c11b9b7e3ef9b3" && \
    mkdir -p /srv/go/src && \
    git clone https://github.com/perkeep/perkeep.git /srv/go/src/perkeep.org && \
    cd /srv/go/src/perkeep.org && \
    git checkout $CAMLISTORE_VERSION && \
    cd - && \
    ls -l /srv/go/src/perkeep.org
WORKDIR /srv/go/src/perkeep.org

VOLUME ["/srv/go/src/perkeep.org/bin"]
