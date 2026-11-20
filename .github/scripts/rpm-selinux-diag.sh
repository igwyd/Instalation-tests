#!/usr/bin/env bash
# SELinux diagnostics for a DS RPM host (CentOS/RHEL). Informational only, always exits 0.
# Why: since DS 10.0.3-58 the RPM labels its ports instead of enabling httpd_can_network_connect;
# on a fresh install nginx -> 127.0.0.1:8000 may fail with "connect() failed (13: Permission denied)" -> 502.
#
# Usage (runs on the remote host, stdin = this script):
#   ssh ec2-user@HOST 'bash -s' < .github/scripts/rpm-selinux-diag.sh

section() { echo; echo "------------- $1 -------------"; }

section "SELinux mode"
getenforce 2>&1
sestatus 2>&1 | head -n 8

section "SELinux booleans (httpd_*network*)"
sudo getsebool -a 2>&1 | grep -E 'httpd_can_network_(connect|relay)|nis_enabled' || true

section "SELinux port labels for DS ports (8000 3000 8080 8083 80)"
if command -v semanage >/dev/null 2>&1; then
  sudo semanage port -l 2>&1 | grep -E '(^|[ ,])(8000|3000|8080|8083|80)([ ,]|$)' || echo "no matching labels"
  echo "--- local (custom) port labels:"
  sudo semanage port -l -C 2>&1 || true
else
  echo "semanage not installed (policycoreutils-python-utils missing)"
fi

section "Package SELinux-related scriptlets"
for p in $(rpm -qa 'onlyoffice-documentserver*'); do
  echo "# $p"
  sudo rpm -q --scripts "$p" 2>&1 | grep -n -i -E 'selinux|semanage|setsebool|restorecon|http_port_t|getenforce' || echo "(no SELinux commands in scriptlets)"
done
rpm -q policycoreutils-python-utils selinux-policy-targeted 2>&1

section "Process contexts / listeners"
ps -eZ 2>&1 | grep -E 'nginx|node|docservice|converter' | head -n 10
sudo ss -ltnp 2>&1 | grep -E ':(8000|3000|8080|8083|80)\b' || true

section "Direct check 127.0.0.1:8000 from the host (ssh context)"
curl -s -o /dev/null -w 'http_code=%{http_code}\n' http://127.0.0.1:8000/healthcheck 2>&1 || true

section "Recent AVC denials"
if command -v ausearch >/dev/null 2>&1 && sudo ausearch -m avc,user_avc -ts recent >/dev/null 2>&1; then
  sudo ausearch -m avc,user_avc -ts recent 2>&1 | tail -n 30
else
  echo "(ausearch unavailable or no records; falling back to journal)"
  sudo journalctl -k --no-pager 2>&1 | grep -i -E 'avc:|denied' | tail -n 20 || true
  sudo grep -h -i 'avc:' /var/log/audit/audit.log 2>/dev/null | tail -n 20 || true
fi

section "nginx upstream errors (last 5)"
sudo grep -h -E 'connect\(\) to .* failed' /var/log/onlyoffice/documentserver/nginx.error.log /var/log/nginx/error.log 2>/dev/null | tail -n 5 || true

exit 0
