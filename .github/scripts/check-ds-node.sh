#!/usr/bin/env bash
# Checks the Node.js version embedded (pkg) in DS binaries inside a Docker container (bug 84664).
# Fixed versions: Node.js 22, 24 or 26. Missing binaries (e.g. adminpanel in CE) are skipped.
# Env: SSH_TARGET (user@ip), SUFFIX (EE|DE|CE), CONTAINER
# Writes NODE_<SUFFIX>_OK, NODE_<SUFFIX>_VERSIONS (unique, one line) and NODE_<SUFFIX>_TEXT (one line per binary, tooltip) to GITHUB_ENV.
RAW=$(ssh -o StrictHostKeyChecking=no "$SSH_TARGET" "sudo docker exec -i $CONTAINER bash -s" 2>/dev/null <<'EOF' || true
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
  N=$((N+1)); v=${v:-?}; major=${v#v}; major=${major%%.*}
  case $major in 22|24|26) mark="✅" ;; *) mark="❌"; OK=false ;; esac
  TEXT+="$mark $(basename "$f"): $v (expected: v22/v24/v26)"$'\n'
  VERS+="$v"$'\n'
done <<< "$RAW"
# no binaries found at all = nothing was checked, not a pass
[ "$N" -gt 0 ] || { OK=false; TEXT="❌ no DS binaries found in $CONTAINER"$'\n'; }
VERS=$(printf '%s' "$VERS" | sort -u | paste -sd' ' -)

printf 'Node.js in binaries %s:\n%s' "$SUFFIX" "$TEXT"
echo "Node.js $SUFFIX OK: $OK"
echo "NODE_${SUFFIX}_OK=$OK" >> "$GITHUB_ENV"
echo "NODE_${SUFFIX}_VERSIONS=${VERS:-none}" >> "$GITHUB_ENV"
{ echo "NODE_${SUFFIX}_TEXT<<NODE_EOF"; printf '%s' "$TEXT"; echo "NODE_EOF"; } >> "$GITHUB_ENV"
