FROM jeanblanchard/alpine-glibc 

COPY ./docker/build/bin/camlistored /usr/local/bin/camlistored
VOLUME ["/etc/camlistore", "/srv/camlistore"]
WORKDIR /srv/camlistore
ENTRYPOINT ["/usr/local/bin/camlistored"]
CMD ["-listen", "0.0.0.0:3179", "-configfile", "/etc/camlistore/server-config.json"]
EXPOSE 3179
