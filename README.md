# Docker AWS & MySQL

An ubuntu docker with all necessary installables that are required to run mysql server & AWS commands inside.

This is intended to be used with GitLab's CI/CD pipeline as a docker image.

| Package                | Version                   |
| ---------------------- | ------------------------- |
| `MAJOR_UBUNTU_VERSION` | `24.04`                   |
| `AWS_CLI_VERSION`      | `2.27.47`                 |
| `MYSQL_VERSION`        | `8.0.42-0ubuntu0.24.04.1` |

## Getting Started

1. Setting up development environment

```bash
    pre-commit install
```

2. Helpful commands

```bash

# Build the docker locally
docker build -t docker-aws-mysql .

# (For debug)
docker build --progress=plain -t docker-aws-mysql .

# Run the docker locally, get into docker
docker run --name docker-aws-mysql --rm -ti docker-aws-mysql bash

```

## Usage

1. On GitLab CI

```yaml
job-build:
  image: swateekj/docker-aws:latest
  stage: build
  script: |
    echo "Your commands go here"
  rules:
    - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
```

2. Testing Image

```bash
echo "USE db; SELECT * FROM users_tbl;" > tmp.sql
export MYSQL_PWD=tmp123
mysql -h "host" -u "user" -D "db" < tmp.sql
```

## Notes

1. Latest `aws-cli` can be looked up from [this link](https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst).

2. Latest `mysql` version needs to be googled to get the exact filename
