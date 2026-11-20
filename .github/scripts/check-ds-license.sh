#!/usr/bin/env bash
# Fail fast when DS (EE) in a Docker container rejects the license (expired / invalid).
# Why: with an expired license DS runs in a degraded mode (1 converter worker, users in view mode), so every
# puppeteer test fails and k6 gets "isSaveLock access deny" - and it takes ~55 min of tests to find that out.
#
# DS re-reads Data/license.lic on file change and logs "[ERROR] ... License: <reason>" to docservice/converter
# out.log within a few seconds. A valid license logs nothing, so we poll for the error until the timeout.
#
# Usage:  CONTAINER=onlyoffice [TIMEOUT=45] [SECRET_NAME=LICENSE_KEY] bash check-ds-license.sh
# Exit:   0 = no license error seen; 1 = license rejected (::error:: + step summary written).

CONTAINER="${CONTAINER:-onlyoffice}"
TIMEOUT="${TIMEOUT:-45}"
SECRET_NAME="${SECRET_NAME:-LICENSE_KEY}"
LOGS="/var/log/onlyoffice/documentserver/converter/out.log /var/log/onlyoffice/documentserver/docservice/out.log"

find_error() {
  docker exec "$CONTAINER" sh -c "grep -h -E '\[ERROR\].*License' $LOGS 2>/dev/null" | tail -n 1
}

deadline=$((SECONDS + TIMEOUT))
while :; do
  line="$(find_error)"
  [ -n "$line" ] && break
  [ "$SECONDS" -ge "$deadline" ] && break
  sleep 5
done

if [ -z "$line" ]; then
  echo "OK: no license error in DS logs after ${TIMEOUT}s (license accepted)"
  exit 0
fi

# "[2026-11-20T08:18:10.501] [ERROR] [localhost] [docId] [userId] nodeJS - License: License expired."
reason="$(printf '%s' "$line" | sed -E 's/.*nodeJS - //')"
echo "---------- license-related lines from DS logs ----------"
docker exec "$CONTAINER" sh -c "grep -h -i -A3 -E '\[ERROR\].*License' $LOGS 2>/dev/null" | head -n 20
echo "--------------------------------------------------------"
echo "::error title=ONLYOFFICE license rejected::DS says '${reason}'. Renew the ${SECRET_NAME} secret (the file has its end date) - tests cannot pass without a valid license."
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "### ❌ DS license rejected"
    echo
    echo "DS log: \`${reason}\`"
    echo
    echo "Renew the \`${SECRET_NAME}\` secret and re-run. Tests were not run: with this license every puppeteer test fails and k6 gets view-only sessions."
  } >> "$GITHUB_STEP_SUMMARY"
fi
exit 1
