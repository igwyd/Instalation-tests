#!/usr/bin/env bash
# Pre-flight check for dev-OS: makes sure everything the matrix jobs download actually exists,
# BEFORE any EC2 instance is created (otherwise every job burns ~10 min of EC2 time and fails).
# Env: ONECLICK_BRANCH, DEV_VERSION, DEV_BUILD. Exit 1 (with ::error:: per problem) if anything is missing.
set -u

: "${ONECLICK_BRANCH:?}" "${DEV_VERSION:?}" "${DEV_BUILD:?}"

S3=https://s3.eu-west-1.amazonaws.com/repo-doc-onlyoffice-com/server/linux
FAILED=0

check_url() { # <description> <url>
  local code
  code=$(curl -sL -o /dev/null -I -w '%{http_code}' --retry 3 --retry-delay 5 "$2")
  if [ "$code" = "200" ]; then
    echo "OK   $1 ($2)"
  else
    echo "::error::$1 not found (HTTP $code): $2"
    FAILED=1
  fi
}

check_url "OneClickInstall-Docs branch '$ONECLICK_BRANCH' (var ONLYOFFICE_ONECLICK_BRANCH)" \
  "https://github.com/ONLYOFFICE/OneClickInstall-Docs/archive/refs/heads/${ONECLICK_BRANCH}.tar.gz"

for arch in amd64 arm64; do
  check_url "DEB package ${DEV_VERSION}-${DEV_BUILD} ${arch} (vars ONLYOFFICE_DEV_VERSION/BUILD)" \
    "$S3/debian/onlyoffice-documentserver-ee_${DEV_VERSION}-${DEV_BUILD}_${arch}.deb"
done
for arch in x86_64 aarch64; do
  check_url "RPM package ${DEV_VERSION}-${DEV_BUILD} ${arch} (vars ONLYOFFICE_DEV_VERSION/BUILD)" \
    "$S3/rhel/onlyoffice-documentserver-ee-${DEV_VERSION}-${DEV_BUILD}.el7.${arch}.rpm"
done

check_url "Docker image onlyoffice/4testing-documentserver-ee:${DEV_VERSION}.${DEV_BUILD}" \
  "https://hub.docker.com/v2/repositories/onlyoffice/4testing-documentserver-ee/tags/${DEV_VERSION}.${DEV_BUILD}"

if [ "$FAILED" -ne 0 ]; then
  echo "::error::Pre-flight check failed, EC2 instances are not started. Check ONLYOFFICE_DEV_VERSION / ONLYOFFICE_DEV_BUILD / ONLYOFFICE_ONECLICK_BRANCH"
  exit 1
fi
