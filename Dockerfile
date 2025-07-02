ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION="24.04"
ARG AWS_CLI_VERSION="2.17.30"
ARG MYSQL_VERSION="8.0.39-0ubuntu0.24.04.2"

FROM ubuntu:${MAJOR_UBUNTU_VERSION} AS build-image
ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION
ARG AWS_CLI_VERSION
ARG MYSQL_VERSION

RUN add-apt-repository ppa:deadsnakes/ppa -y

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        jq \
        openssh-client \
        software-properties-common \
        apt-transport-https \
        mysql-client=${MYSQL_VERSION} \
        python3.12 \
        python3.12-venv \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS -O "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" && \
    unzip -qq awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip && \
    ./aws/install && \
    rm -rf aws awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip

RUN apt-get clean
