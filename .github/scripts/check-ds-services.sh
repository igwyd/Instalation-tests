#!/usr/bin/env bash
# Checks the default state of DS services.
#   on  = enabled (systemd) / RUNNING (supervisor): converter, docservice; adminpanel in EE/DE since 10.0
#   off = not enabled / not RUNNING: example, metrics everywhere; adminpanel in CE (it does not exist there)
# Before 10.0 adminpanel is not checked in EE/DE.
# Env: SSH_TARGET (user@ip), SUFFIX (EE|DE|CE), VERSION (X.Y.Z[-BUILD]), CONTAINER (set = docker mode)
# Writes SERVICES_<SUFFIX>_OK and SERVICES_<SUFFIX>_TEXT (one line per service, for the dashboard tooltip) to GITHUB_ENV.
remote() { ssh -o StrictHostKeyChecking=no "$SSH_TARGET" "$@" 2>/dev/null; }

ED=${SUFFIX,,}
MAJOR=${VERSION%%.*}
if [ "$ED" = ce ]; then ADMIN=off; elif [ "${MAJOR:-0}" -ge 10 ] 2>/dev/null; then ADMIN=on; else ADMIN=-; fi

if [ -n "${CONTAINER:-}" ]; then
  RAW=$(remote "sudo docker exec $CONTAINER supervisorctl status all" || true)
  state() { echo "$RAW" | awk -v n="ds:$1" '$1==n{print $2; f=1} END{if(!f) print "absent"}'; }
  is_on() { [ "$1" = RUNNING ]; }
else
  RAW=$(remote 'for s in converter docservice adminpanel example metrics; do echo "$s $(systemctl is-enabled ds-$s 2>/dev/null | head -1) $(systemctl is-active ds-$s 2>/dev/null | head -1)"; done' || true)
  state() { echo "$RAW" | awk -v n="$1" '$1==n{print ($2==""?"not-found":$2) "/" ($3==""?"-":$3); f=1} END{if(!f) print "absent"}'; }
  is_on() { [ "${1%%/*}" = enabled ]; }
fi

PFX=ds-; [ -n "${CONTAINER:-}" ] && PFX=ds:
OK=true; TEXT=""
for pair in converter:on docservice:on adminpanel:$ADMIN example:off metrics:off; do
  svc=${pair%%:*}; want=${pair##*:}
  st=$(state "$svc"); mark="✅"
  case $want in
    on)  is_on "$st" || { mark="❌"; OK=false; } ; exp="enabled" ;;
    off) is_on "$st" && { mark="❌"; OK=false; } ; exp="disabled" ;;
    *)   mark="➖"; exp="not checked" ;;
  esac
  TEXT+="$mark ${PFX}$svc: $st (expected: $exp)"$'\n'
done

printf 'Services %s:\n%s' "$SUFFIX" "$TEXT"
echo "Services $SUFFIX OK: $OK"
echo "SERVICES_${SUFFIX}_OK=$OK" >> "$GITHUB_ENV"
{ echo "SERVICES_${SUFFIX}_TEXT<<SVC_EOF"; printf '%s' "$TEXT"; echo "SVC_EOF"; } >> "$GITHUB_ENV"
