FROM jeanblanchard/alpine-glibc 

COPY ./docker/build/bin/camlistored /usr/local/bin/camlistored
RUN mkdir -p /root/.config && ln -s /root/.config/camlistore /etc/camlistore
VOLUME ["/etc/camlistore", "/srv/camlistore"]

EXPOSE 3179
ENTRYPOINT ["/usr/local/bin/camlistored"]
CMD ["-listen", "0.0.0.0:3179", "-configfile", "/etc/camlistore/server-config.json"]
