#!/usr/bin/env bash
# Compares the DS version from every source with EXPECTED (VERSION-BUILD):
#   - installed package (dpkg / rpm, ".elN" suffix of RPM is ignored)
#   - /info/info.json (answers only locally: on the host or inside the container)
#   - docker image tag the container was started from (docker mode only, 9.3.0.138 -> 9.3.0-138)
# Env: SSH_TARGET (user@ip), PKG, SUFFIX, EXPECTED (empty = sources must match the package version),
#      CONTAINER (set = docker mode)
# Writes VERSION_<SUFFIX>_OK and VERSION_<SUFFIX>_ACTUAL to GITHUB_ENV.
remote() { ssh -o StrictHostKeyChecking=no "$SSH_TARGET" "$@" 2>/dev/null; }

if [ -n "${CONTAINER:-}" ]; then
  PKG_VER=$(remote "sudo docker exec $CONTAINER dpkg-query -W -f='\${Version}' $PKG")
  INFO=$(remote "sudo docker exec $CONTAINER curl -s http://127.0.0.1/info/info.json")
  TAG=$(remote "sudo docker inspect -f '{{.Config.Image}}' $CONTAINER")
  TAG=${TAG##*:}
  TAG_VER=${TAG%.*}-${TAG##*.}
else
  PKG_VER=$(remote "dpkg-query -W -f='\${Version}' $PKG 2>/dev/null || rpm -q --queryformat '%{VERSION}-%{RELEASE}' $PKG")
  INFO=$(remote "curl -s http://127.0.0.1:8000/info/info.json")
fi
PKG_VER=${PKG_VER:-not-found}
INFO_VER=$(echo "$INFO" | jq -r 'first(.. | objects | select(has("buildVersion"))) | "\(.buildVersion)-\(.buildNumber)"' 2>/dev/null)
INFO_VER=${INFO_VER:-not-found}
EXPECTED=${EXPECTED:-${PKG_VER%.el*}}

echo "Version $SUFFIX: package=$PKG_VER, info.json=$INFO_VER${CONTAINER:+, docker tag=$TAG_VER}, expected=$EXPECTED"
OK=true
for v in "${PKG_VER%.el*}" "$INFO_VER" ${CONTAINER:+"$TAG_VER"}; do
  [ "$v" = "$EXPECTED" ] && [ "$v" != not-found ] || OK=false
done
if $OK; then ACTUAL=$PKG_VER; else ACTUAL="pkg=$PKG_VER info=$INFO_VER${CONTAINER:+ tag=$TAG_VER}"; fi
echo "Version $SUFFIX OK: $OK"
echo "VERSION_${SUFFIX}_OK=$OK" >> "$GITHUB_ENV"
echo "VERSION_${SUFFIX}_ACTUAL=$ACTUAL" >> "$GITHUB_ENV"
