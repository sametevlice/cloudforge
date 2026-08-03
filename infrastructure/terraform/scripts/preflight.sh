#!/usr/bin/env bash

set -Eeuo pipefail

AWS_PROFILE_NAME="${AWS_PROFILE:-default}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Eksik komut: $1" >&2
    exit 1
  fi
}

echo "CloudForge Terraform preflight"
echo

require_command terraform
require_command aws

echo "Terraform:"
terraform version | head -n 1

echo
echo "AWS CLI:"
aws --version

echo
echo "AWS profile: ${AWS_PROFILE_NAME}"
AWS_PROFILE="${AWS_PROFILE_NAME}" aws sts get-caller-identity

echo
echo "Preflight başarılı."
