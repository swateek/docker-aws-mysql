ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION="24.04"
ARG AWS_CLI_VERSION="2.27.47"
ARG MYSQL_VERSION="8.0.46-0ubuntu0.24.04.3"
ARG UV_VERSION="0.11.28"

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM ubuntu:${MAJOR_UBUNTU_VERSION} AS build-image
ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION
ARG AWS_CLI_VERSION
ARG MYSQL_VERSION

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        jq \
        openssh-client \
        mysql-client=${MYSQL_VERSION} \
        python3 \
        python3.12 && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS -O "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" \
    && unzip -qq "awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" \
    && ./aws/install \
    && rm -rf aws "awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip"

COPY --from=uv /uv /uvx /usr/local/bin/
RUN uv --version
