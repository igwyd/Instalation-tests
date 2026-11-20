#!/usr/bin/env bash
# k6 load-test diagnostics for dev-DB-check (DS in Docker on the GitHub runner). Informational only, exit 0.
# Why: on DS 10.0.3-58 k6 gets "websocket: close 1005", open/convert ~12 s instead of ~60 ms.
# Need to tell apart "runner overloaded by 500 VU" from "DS regression".
#
#   k6-diag.sh start            # before k6: runner info + background docker stats sampler
#   k6-diag.sh report [name]    # after k6 (if: always()): stop sampler, print stats and unfiltered DS/nginx logs
#
# CONTAINER (default: onlyoffice), DB_CONTAINER (optional) and INTERVAL (default: 10 s) are taken from env.

CONTAINER="${CONTAINER:-onlyoffice}"
DB_CONTAINER="${DB_CONTAINER:-}"
INTERVAL="${INTERVAL:-10}"
STATS=/tmp/k6-docker-stats.log
PIDFILE=/tmp/k6-docker-stats.pid

section() { echo; echo "------------- $1 -------------"; }

case "${1:-}" in
  start)
    section "runner resources"
    nproc; free -m; df -h / | tail -n 1; uptime
    : > "$STATS"
    (
      while true; do
        echo "### $(date -u +%H:%M:%S) load: $(cut -d' ' -f1-3 /proc/loadavg)" >> "$STATS"
        docker stats --no-stream --format '{{.Name}} cpu={{.CPUPerc}} mem={{.MemUsage}} ({{.MemPerc}}) net={{.NetIO}} pids={{.PIDs}}' \
          "$CONTAINER" ${DB_CONTAINER:+"$DB_CONTAINER"} >> "$STATS" 2>&1
        sleep "$INTERVAL"
      done
    ) >/dev/null 2>&1 &
    echo $! > "$PIDFILE"
    echo "docker stats sampler started (pid $(cat "$PIDFILE"), every ${INTERVAL}s) -> $STATS"
    ;;

  report)
    [ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null

    section "docker stats during k6 (every ${INTERVAL}s)"
    cat "$STATS" 2>/dev/null || echo "no samples"

    section "container state"
    docker inspect "$CONTAINER" --format 'status={{.State.Status}} oom_killed={{.State.OOMKilled}} restarts={{.RestartCount}} exit={{.State.ExitCode}}' 2>&1

    section "supervisorctl status"
    docker exec "$CONTAINER" supervisorctl status 2>&1 | head -n 20

    section "docservice out.log (last 80, unfiltered)"
    docker exec "$CONTAINER" tail -n 80 /var/log/onlyoffice/documentserver/docservice/out.log 2>&1

    section "docservice err.log (last 40)"
    docker exec "$CONTAINER" tail -n 40 /var/log/onlyoffice/documentserver/docservice/err.log 2>&1

    section "converter out.log (last 40)"
    docker exec "$CONTAINER" tail -n 40 /var/log/onlyoffice/documentserver/converter/out.log 2>&1

    section "nginx error.log (last 30)"
    docker exec "$CONTAINER" tail -n 30 /var/log/onlyoffice/documentserver/nginx.error.log 2>&1

    section "counts in docservice/converter logs"
    for pat in 'WARN' 'ERROR' 'timeout' 'ECONN' 'too many' 'limit' 'license' 'connections'; do
      printf '%-14s docservice=%s converter=%s\n' "$pat" \
        "$(docker exec "$CONTAINER" sh -c "grep -c -i -- '$pat' /var/log/onlyoffice/documentserver/docservice/out.log" 2>/dev/null)" \
        "$(docker exec "$CONTAINER" sh -c "grep -c -i -- '$pat' /var/log/onlyoffice/documentserver/converter/out.log" 2>/dev/null)"
    done

    section "runner"
    uptime; free -m | head -n 2
    ;;

  *)
    echo "usage: $0 start|report"
    ;;
esac

exit 0
