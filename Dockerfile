FROM registry.access.redhat.com/ubi9/ubi as downloader
ARG SHP_VERSION=0.12.0
RUN curl -L -o /tmp/shp.tar.gz https://github.com/shipwright-io/cli/releases/download/v${SHP_VERSION}/cli_${SHP_VERSION}_linux_x86_64.tar.gz && \
    cd /tmp && \
    tar xvfz shp.tar.gz && \
    rm -rf shp.tar.gz

FROM registry.access.redhat.com/ubi9/ubi-micro
COPY --from=downloader /tmp/shp /usr/local/bin/