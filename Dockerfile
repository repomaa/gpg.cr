FROM alpine:latest
RUN apk update && apk add alpine-sdk crystal shards musl-dev yaml-dev libxml2-dev libressl-dev zlib-dev git gnupg gpgme-dev
