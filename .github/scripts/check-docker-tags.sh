#!/bin/bash
# Проверка тегов релизного образа на Docker Hub: latest, X.Y, X.Y.Z, X.Y.Z.BUILD должны указывать на один и тот же образ.
# Env: REPO (например onlyoffice/documentserver-ee), SUFFIX (EE/DE/CE), VERSION (X.Y.Z, без билда),
# BUILD (номер билда протестированного образа — 4-й тег X.Y.Z.BUILD; пусто или не число — проверка падает).
# Пишет в GITHUB_ENV: TAGS_<SUFFIX>_OK (true/false), TAGS_<SUFFIX>_TEXT (по строке на тег).
set -u
V="${VERSION%%-*}"; B="${BUILD:-}"
TAGS="latest ${V%.*} $V"
[[ "$B" =~ ^[0-9]+$ ]] && TAGS="$TAGS $V.$B"
ACCEPT="application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.v2+json"
TOKEN=$(curl -fsS "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPO:pull" | jq -r .token)

OK=true; TEXT=""; REF=""
[[ "$B" =~ ^[0-9]+$ ]] || { OK=false; TEXT="не удалось определить билд образа (BUILD='$B') — тег $V.BUILD не проверен"$'
'; echo "$TEXT"; }
for T in $TAGS; do
  # HEAD манифеста: Docker-Content-Digest — digest индекса (всех платформ), без скачивания образа
  D=$(curl -fsSI -H "Authorization: Bearer $TOKEN" -H "Accept: $ACCEPT" "https://registry-1.docker.io/v2/$REPO/manifests/$T" \
        | tr -d '\r' | awk -F': ' 'tolower($1)=="docker-content-digest"{print $2}')
  [ -z "$REF" ] && REF="$D"          # первый тег (latest) — эталон
  if [ -z "$D" ]; then OK=false; LINE="$REPO:$T — тега нет"
  elif [ "$D" != "$REF" ]; then OK=false; LINE="$REPO:$T $D — НЕ совпадает с latest ($REF)"
  else LINE="$REPO:$T $D"; fi
  echo "$LINE"; TEXT="$TEXT$LINE"$'\n'
done
[ -z "$REF" ] && OK=false
echo "Tags $SUFFIX: ok=$OK"
{
  echo "TAGS_${SUFFIX}_OK=$OK"
  echo "TAGS_${SUFFIX}_TEXT<<EOF_TAGS"
  printf '%s' "$TEXT"
  echo "EOF_TAGS"
} >> "$GITHUB_ENV"
