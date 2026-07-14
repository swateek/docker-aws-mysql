#!/usr/bin/env bash
# Smoke tests for docker-aws-mysql image tools.
# Intended to run inside the built container.
set -euo pipefail

echo "==> Checking required binaries are on PATH"
for cmd in mysql mysqldump python3 python3.12 uv uvx aws jq curl unzip ssh bash; do
  command -v "$cmd" >/dev/null || {
    echo "FAIL: $cmd not found on PATH" >&2
    exit 1
  }
  echo "  OK: $cmd -> $(command -v "$cmd")"
done

echo "==> Printing tool versions"
mysql --version
mysqldump --version
python3 --version
python3.12 --version
uv --version
uvx --version
aws --version
jq --version

echo "==> Smoke-checking help / basic invocation"
mysql --help >/dev/null
mysqldump --help >/dev/null
# aws help needs groff/mandoc (not in image); configure list exercises the CLI offline
aws configure list >/dev/null

echo "==> Validating HTTPS / CA certificates"
curl -fsSI https://aws.amazon.com >/dev/null

echo "==> Exercising python3 -m venv (ensurepip / python3.12-venv)"
# Databricks and other CI scripts use stdlib venv; uv venv alone is not enough.
python3 -m venv /tmp/pyvenv
/tmp/pyvenv/bin/python3 -c "import ensurepip; print('ensurepip ok')"
rm -rf /tmp/pyvenv

echo "==> Exercising uv venv + pip install"
uv venv /tmp/tvenv
uv pip install --python /tmp/tvenv/bin/python cowsay
/tmp/tvenv/bin/python -c "import cowsay; cowsay.cow('smoke ok')"

echo "==> All smoke checks passed"
