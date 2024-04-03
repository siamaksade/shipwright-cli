FROM registry.access.redhat.com/ubi9/ubi as downloader

ARG SHP_VERSION=1.0.1-222

RUN curl -L -o /tmp/shp.tar.gz https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-builds/${SHP_VERSION}/shp-linux-amd64.tar.gz && \
    cd /tmp && \
    tar xvfz shp.tar.gz && \
    rm -rf shp.tar.gz

FROM registry.access.redhat.com/ubi9/ubi-micro
COPY --from=downloader /tmp/shp-linux-amd64 /usr/local/bin/shp