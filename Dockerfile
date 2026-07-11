ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION="24.04"
ARG AWS_CLI_VERSION="2.27.47"
ARG MYSQL_VERSION="8.0.46-0ubuntu0.24.04.3"
ARG UV_VERSION="0.11.28"

# ARG expansion works in FROM; COPY --from does not accept ${UV_VERSION} in the image ref
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM ubuntu:${MAJOR_UBUNTU_VERSION} AS build-image
ARG BUILD_VERSION
ARG MAJOR_UBUNTU_VERSION
ARG AWS_CLI_VERSION
ARG MYSQL_VERSION

# RUN apt-get -qq update
# RUN apt install -qq -y curl unzip jq openssh-client mysql-client=${MYSQL_VERSION}
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

RUN curl -sS -O 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64-'${AWS_CLI_VERSION}'.zip'
RUN unzip -qq awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
RUN ./aws/install
RUN rm -rf aws awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip

# Install uv (Astral) for Python package/project management in CI
COPY --from=uv /uv /uvx /bin/

RUN apt-get clean
