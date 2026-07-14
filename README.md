# Docker AWS & MySQL

An ubuntu docker with all necessary installables that are required to run mysql server & AWS commands inside.

This is intended to be used with GitLab's CI/CD pipeline as a docker image.

| Package                | Version                   |
| ---------------------- | ------------------------- |
| `MAJOR_UBUNTU_VERSION` | `24.04`                   |
| `AWS_CLI_VERSION`      | `2.27.47`                 |
| `MYSQL_VERSION`        | `8.0.46-0ubuntu0.24.04.3` |
| `UV_VERSION`           | `0.11.28`                 |

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

# Verify installed tools and image size
docker images docker-aws-mysql
docker run --rm docker-aws-mysql bash -lc 'uv --version && aws --version && python3 --version && python3 -m venv /tmp/pyvenv && mysql --version'

```

## CI / testing

Pre-merge CI builds the image (no push) and runs smoke checks for installed tools, plus a MySQL client SQL round-trip against a temporary MySQL service.

```bash
# Build for local smoke tests
docker build -t docker-aws-mysql:ci .

# Run the smoke script inside the image
docker run --rm -v "$PWD/tests:/tests:ro" docker-aws-mysql:ci bash /tests/smoke.sh
```

## Usage

1. On GitLab CI

```yaml
job-build:
  image: swateekj/docker-aws-mysql:latest
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

3. Latest `uv` version can be looked up from [GitHub releases](https://github.com/astral-sh/uv/releases).

4. Python package management uses `uv` (not apt `python3-pip`). Prefer `uv pip`, `uv venv`, or `uv run` in CI jobs. `python3` and `python3.12-venv` remain installed so scripts that call `python3 -m venv` (e.g. Databricks deploy) still work.
