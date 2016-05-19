FROM mkorenkov/alpine

VOLUME ["/srv/camlistore"]

COPY ./bin/camtool /usr/local/bin/camtool
COPY ./entry.sh /usr/local/bin/docker-entry.sh
# explicitly set user/group IDs
RUN addgroup -S -g 999 camlistore && \
    adduser -S -h /srv/camlistore -u 999 -G camlistore camlistore && \
    apk add --update bash

ENTRYPOINT ["/usr/local/bin/docker-entry.sh"]
