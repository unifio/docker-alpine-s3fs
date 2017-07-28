FROM alpine:3.6
MAINTAINER "Unif.io, Inc. <support@unif.io>"

# the following ENV need to be present
ENV IAM_ROLE=none
ENV MOUNT_POINT=/var/s3
VOLUME /var/s3

ARG S3FS_VERSION=1.82

RUN apk --update --no-cache add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev libressl-dev tar bash; \
    \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    \
    curl -o v${S3FS_VERSION}.tar.gz -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v${S3FS_VERSION}.tar.gz; \
    tar xvz -f /tmp/build/v${S3FS_VERSION}.tar.gz; \
    cd s3fs-fuse-${S3FS_VERSION} && ./autogen.sh && ./configure --prefix=/usr && make && make install; \
    \
    cd /tmp; \
    rm -rf /tmp/build

COPY docker-entrypoint.sh /
COPY mime.types /etc

ENTRYPOINT ["/docker-entrypoint.sh"]
