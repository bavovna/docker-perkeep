FROM golang:1.17 AS build
RUN export PERKEEP_DIR="/go/src/github.com/perkeep/perkeep" && \
    export PERKEEP_VERSION="c2e31370ddefd86b6112a5d891100ea3382a4254" && \
    mkdir -p "/go/src/github.com/perkeep" && \
    git clone "https://github.com/perkeep/perkeep.git" "$PERKEEP_DIR" && \
    cd "$PERKEEP_DIR" && \
    git reset --hard "$PERKEEP_VERSION" && \
    go run make.go --sqlite=false -static=true -v

FROM alpine:latest AS certs
RUN apk --update add ca-certificates

FROM alpine:latest
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/bin/pk* /bin/
COPY --from=build /go/bin/perkeepd /bin/

# explicitly set user/group IDs
RUN addgroup -S -g 1000 perkeep && \
    adduser -S -h /srv/perkeep -u 1000 -G perkeep perkeep && \
    apk add --update \
        bash \
        bind-tools \
        ffmpeg \
        imagemagick \
        libjpeg-turbo-utils \
        su-exec \
        tzdata

WORKDIR /srv/perkeep

EXPOSE 3179
VOLUME ["/srv/camlistore"]
ENTRYPOINT ["su-exec", "perkeep"]
CMD ["/bin/perkeepd", "-listen", "0.0.0.0:3179"]

