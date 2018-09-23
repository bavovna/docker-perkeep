FROM mkorenkov/go:latest as builder

ENV GOPATH="/srv/go"
RUN export SRC_DIR="/srv/go/src" && \
    export CAMLISTORE_VERSION="ad6dae391e62c3689d68e27e91c11b9b7e3ef9b3" && \
    export IMAGE_MAGIC_VERSION="859511c029bb8e9ea02037f5672e0fd741abf414" && \
    apk add --no-cache \
    git alpine-sdk automake autoconf libtool \
    libjpeg-turbo-dev bash && \
    mkdir -p "$SRC_DIR" && \
    git clone "https://github.com/strukturag/libde265.git" "$SRC_DIR/libde265" && \
    cd "$SRC_DIR/libde265" && \
    ./autogen.sh && \
    ./configure && \
    make install && \
    git clone "https://github.com/ImageMagick/ImageMagick.git" "$SRC_DIR/ImageMagick" && \
    cd "$SRC_DIR/ImageMagick" && \
    git reset --hard "$IMAGE_MAGIC_VERSION" && \
    ./configure --with-heic=yes --with-jpeg=true --enable-zero-configuration && \
    make && \
    make install && \
    git clone "https://github.com/perkeep/perkeep.git" "$SRC_DIR/perkeep.org" && \
    cd "$SRC_DIR/perkeep.org" && \
    git reset --hard "$CAMLISTORE_VERSION" && \
    go run make.go --sqlite=false -static=true -v && \
    ls -l "/srv/go/bin"

FROM mkorenkov/alpine

COPY --from=builder /usr/local/lib/libMagickCore-7.Q16HDRI.so.5 /usr/local/lib/libMagickCore-7.Q16HDRI.so.5
COPY --from=builder /usr/local/lib/libMagickWand-7.Q16HDRI.so.5 /usr/local/lib/libMagickWand-7.Q16HDRI.so.5
COPY --from=builder /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/lib/libjpeg.so.8 /usr/lib/libjpeg.so.8
COPY --from=builder /usr/local/lib/libde265.so.0 /usr/local/lib/libde265.so.0
COPY --from=builder /usr/lib/libgomp.so.1 /usr/lib/libgomp.so.1
COPY --from=builder /usr/local/etc/ImageMagick-7/magic.xml /usr/local/etc/ImageMagick-7/magic.xml

COPY --from=builder /usr/local/bin/convert /usr/local/bin/convert
COPY --from=builder /usr/local/bin/magick /usr/local/bin/magick

COPY --from=builder /srv/go/bin/perkeepd /usr/local/bin/perkeepd
COPY --from=builder /srv/go/bin/pk /usr/local/bin/pk
COPY ./entry.sh /usr/local/bin/docker-entry.sh

# explicitly set user/group IDs
RUN addgroup -S -g 999 camlistore && \
    adduser -S -h /srv/camlistore -u 999 -G camlistore camlistore && \
    apk add --update bash libjpeg-turbo-utils tzdata

EXPOSE 3179
ENTRYPOINT ["/usr/local/bin/docker-entry.sh"]
CMD ["/usr/local/bin/perkeepd", "-listen", "0.0.0.0:3179"]

