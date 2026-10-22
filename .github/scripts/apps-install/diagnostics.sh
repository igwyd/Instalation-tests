#!/bin/bash
# Runs on the instance as root (ssh 'sudo bash -s' < this file): what the installer's "OK"/"Thank you" does not tell -
# failed units, container states and logs, SELinux denials. Taken after the Apps install and again after its uninstall.
echo "### listening ports"; ss -lntp
echo "### failed systemd units"; systemctl --failed --no-pager
for u in $(systemctl list-units --failed --plain --no-legend | awk '{print $1}'); do
  echo "### journal $u"; journalctl -u "$u" -n 80 --no-pager
done
# nginx of Docs is restarted on every port move, its failures are the usual reason why Docs is gone
echo "### journal nginx"; journalctl -u nginx -n 40 --no-pager 2>/dev/null
if command -v getenforce >/dev/null; then
  # bind() to a port outside http_port_t fails with "Permission denied" when enforcing (seen on CentOS 9, port 8083)
  echo "### selinux"; getenforce
  echo "### http_port_t"; semanage port -l 2>/dev/null | grep -w http_port_t
  echo "### locally added port labels"; semanage port -l -C 2>/dev/null
  echo "### AVC denials"; ausearch -m avc -ts today 2>/dev/null | tail -n 40
fi
if command -v docker >/dev/null; then
  echo "### docker ps -a"; docker ps -a --format 'table {{.Names}}	{{.Image}}	{{.Status}}	{{.Ports}}'
  for c in $(docker ps -a --format '{{.Names}}'); do echo "### docker logs $c"; docker logs --tail 80 "$c" 2>&1; done
fi
echo "### openresty/nginx configs with ssl"; grep -rlE 'listen\s+\S*443|ssl_certificate' /etc/openresty /etc/nginx 2>/dev/null
