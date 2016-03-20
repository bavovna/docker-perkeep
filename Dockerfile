FROM mkorenkov/alpine 

VOLUME ["/srv/camlistore"]

COPY ./docker/build/bin/camlistored /usr/local/bin/camlistored
COPY ./docker/entry.sh /usr/local/bin/docker-entry.sh
# explicitly set user/group IDs
RUN addgroup -S -g 999 camlistore && \
    adduser -S -h /srv/camlistore -u 999 -G camlistore camlistore && \
    apk add --update bash 

EXPOSE 3179
ENTRYPOINT ["/usr/local/bin/docker-entry.sh"]
CMD ["-listen", "0.0.0.0:3179"]
