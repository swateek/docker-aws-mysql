ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION="24.04"
ARG AWS_CLI_VERSION="2.27.47"
ARG MYSQL_VERSION="8.0.46-0ubuntu0.24.04.3"
ARG UV_VERSION="0.11.28"

FROM ubuntu:${MAJOR_UBUNTU_VERSION} AS build-image
ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION
ARG AWS_CLI_VERSION
ARG MYSQL_VERSION
ARG UV_VERSION

# RUN apt-get -qq update
# RUN apt install -qq -y curl unzip jq openssh-client mysql-client=${MYSQL_VERSION}
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
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

RUN curl -sS -O 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64-'${AWS_CLI_VERSION}'.zip'
RUN unzip -qq awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
RUN ./aws/install
RUN rm -rf aws awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip

# Install uv into /usr/local/bin so it is always on PATH for CI jobs
ADD https://astral.sh/uv/${UV_VERSION}/install.sh /tmp/uv-installer.sh
RUN sh /tmp/uv-installer.sh \
    && install -m 0755 /root/.local/bin/uv /root/.local/bin/uvx /usr/local/bin/ \
    && rm -f /tmp/uv-installer.sh \
    && uv --version

RUN apt-get clean
