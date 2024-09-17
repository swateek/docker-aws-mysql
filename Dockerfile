ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION="24.04"
ARG AWS_CLI_VERSION="2.17.30"
ARG MYSQL_VERSION="8.0.39-0ubuntu0.24.04.2"

FROM ubuntu:${MAJOR_UBUNTU_VERSION} AS build-image
ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION
ARG AWS_CLI_VERSION
ARG MYSQL_VERSION

RUN apt-get -qq update
RUN apt install -qq -y curl unzip jq openssh-client mysql-client=${MYSQL_VERSION}
RUN curl -sS -O 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64-'${AWS_CLI_VERSION}'.zip'
RUN unzip -qq awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
RUN ./aws/install
RUN rm -rf aws awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip

RUN apt-get clean
