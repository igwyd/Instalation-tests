#!/bin/bash
# Checks release image tags on Docker Hub: latest, X.Y, X.Y.Z, X.Y.Z.BUILD must point to the same image.
# Env: REPO (e.g. onlyoffice/documentserver-ee), SUFFIX (EE/DE/CE), VERSION (X.Y.Z, without build),
# BUILD (build number of the tested image - the 4th tag X.Y.Z.BUILD; empty or not a number fails the check).
# Writes to GITHUB_ENV: TAGS_<SUFFIX>_OK (true/false), TAGS_<SUFFIX>_TEXT (one line per tag).
set -u
V="${VERSION%%-*}"; B="${BUILD:-}"
TAGS="latest ${V%.*} $V"
[[ "$B" =~ ^[0-9]+$ ]] && TAGS="$TAGS $V.$B"
ACCEPT="application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.v2+json"
TOKEN=$(curl -fsS "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPO:pull" | jq -r .token)

OK=true; TEXT=""; REF=""
[[ "$B" =~ ^[0-9]+$ ]] || { OK=false; TEXT="could not determine the image build (BUILD='$B') - tag $V.BUILD not checked"$'
'; echo "$TEXT"; }
for T in $TAGS; do
  # Manifest HEAD: Docker-Content-Digest is the index digest (all platforms), the image is not pulled
  D=$(curl -fsSI -H "Authorization: Bearer $TOKEN" -H "Accept: $ACCEPT" "https://registry-1.docker.io/v2/$REPO/manifests/$T" \
        | tr -d '\r' | awk -F': ' 'tolower($1)=="docker-content-digest"{print $2}')
  [ -z "$REF" ] && REF="$D"          # the first tag (latest) is the reference
  if [ -z "$D" ]; then OK=false; LINE="$REPO:$T - tag not found"
  elif [ "$D" != "$REF" ]; then OK=false; LINE="$REPO:$T $D - does NOT match latest ($REF)"
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
