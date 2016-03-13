FROM jeanblanchard/alpine-glibc

COPY ./docker/build/bin/camlistored /usr/local/bin/camlistored
# explicitly set user/group IDs
RUN export GOSU_VERSION="1.7" && \
    groupadd -r camlistore --gid=999 && useradd -r -g camlistore --uid=999 --home-dir=/srv/camlistore camlistore && \
    apk add --update curl gnupg && \
    apk add --update sqlite-libs && \
    curl -L -o /tmp/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" && \
    curl -L -o /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && echo "keyserver done" && \
    gpg --batch --verify /tmp/gosu.asc /tmp/gosu && \
    rm -r "$GNUPGHOME" /tmp/gosu.asc && \
    mv /tmp/gosu /usr/local/bin/ && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    apk del curl gnupg
VOLUME ["/srv/camlistore"]

EXPOSE 3179
ENTRYPOINT ["/usr/local/bin/camlistored"]
CMD ["-listen", "0.0.0.0:3179"]
