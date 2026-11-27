#!/usr/bin/env bash
# Checks the Node.js version embedded (pkg) in DS binaries (bug 84664): inside a Docker container
# (CONTAINER set, dev-Docker-DEB) or directly on the host (CONTAINER empty, DEB/RPM package install).
# Every binary must be built with exactly EXPECTED_NODE (repo variable ONLYOFFICE_NODEJS_VERSION, e.g. v24.22.3).
# Missing binaries (e.g. adminpanel in CE) are skipped.
# Env: SSH_TARGET (user@ip), SUFFIX (EE|DE|CE|EE_UPGRADE), CONTAINER (optional), EXPECTED_NODE (with or without leading "v")
# Writes NODE_<SUFFIX>_OK, NODE_<SUFFIX>_VERSIONS (unique, one line) and NODE_<SUFFIX>_TEXT (one line per binary, tooltip) to GITHUB_ENV.
EXPECTED_NODE="v${EXPECTED_NODE#v}"
if [ "$EXPECTED_NODE" = "v" ]; then
  echo "::error::Repository variable ONLYOFFICE_NODEJS_VERSION is not set (expected Node.js version, e.g. v24.22.3)"
  echo "NODE_${SUFFIX}_OK=false" >> "$GITHUB_ENV"
  echo "NODE_${SUFFIX}_VERSIONS=none" >> "$GITHUB_ENV"
  { echo "NODE_${SUFFIX}_TEXT<<NODE_EOF"; echo "❌ ONLYOFFICE_NODEJS_VERSION is not set"; echo "NODE_EOF"; } >> "$GITHUB_ENV"
  exit 1
fi

if [ -n "$CONTAINER" ]; then REMOTE="sudo docker exec -i $CONTAINER bash -s"; WHERE="container $CONTAINER"
else REMOTE="sudo bash -s"; WHERE="host $SSH_TARGET"; fi
RAW=$(ssh -o StrictHostKeyChecking=no "$SSH_TARGET" "$REMOTE" 2>/dev/null <<'EOF' || true
for f in /var/www/onlyoffice/documentserver/server/DocService/docservice \
         /var/www/onlyoffice/documentserver/server/FileConverter/converter \
         /var/www/onlyoffice/documentserver/server/Metrics/metrics \
         /var/www/onlyoffice/documentserver/server/AdminPanel/server/adminpanel \
         /var/www/onlyoffice/documentserver-example/example \
         /var/www/onlyoffice/documentserver/npm/json; do
  [ -f "$f" ] && echo "$f $(grep -aoE 'nodejs\.org/download/release/v[0-9]+\.[0-9]+\.[0-9]+' "$f" | head -1 | grep -oE 'v[0-9.]+$')"
done
EOF
)

OK=true; TEXT=""; VERS=""; N=0
while read -r f v; do
  [ -z "$f" ] && continue
  N=$((N+1)); v=${v:-?}
  if [ "$v" = "$EXPECTED_NODE" ]; then mark="✅"; else mark="❌"; OK=false; fi
  TEXT+="$mark $(basename "$f"): $v (expected: $EXPECTED_NODE)"$'\n'
  VERS+="$v"$'\n'
done <<< "$RAW"
# no binaries found at all = nothing was checked, not a pass
[ "$N" -gt 0 ] || { OK=false; TEXT="❌ no DS binaries found in $WHERE"$'\n'; }
VERS=$(printf '%s' "$VERS" | sort -u | paste -sd' ' -)

printf 'Node.js in binaries %s (expected %s):\n%s' "$SUFFIX" "$EXPECTED_NODE" "$TEXT"
echo "Node.js $SUFFIX OK: $OK"
[ "$OK" = true ] || echo "::error::Node.js in $SUFFIX binaries: ${VERS:-none}, expected $EXPECTED_NODE (ONLYOFFICE_NODEJS_VERSION)"
echo "NODE_${SUFFIX}_OK=$OK" >> "$GITHUB_ENV"
echo "NODE_${SUFFIX}_VERSIONS=${VERS:-none}" >> "$GITHUB_ENV"
{ echo "NODE_${SUFFIX}_TEXT<<NODE_EOF"; printf '%s' "$TEXT"; echo "NODE_EOF"; } >> "$GITHUB_ENV"
