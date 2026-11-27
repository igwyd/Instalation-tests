#!/usr/bin/env bash
# Prepare a stock MSSQL container (mcr.microsoft.com/mssql/server) for ONLYOFFICE Docs:
# wait until SQL Server accepts connections, then create the database, a SQL login,
# a database user (db_owner) and verify that this user can connect.
# DS creates its tables itself on first start (run-document-server.sh -> mssql_tbl).
#
# Env:
#   CONTAINER  - MSSQL container name (required)
#   SA_PWD     - sa password, as passed in MSSQL_SA_PASSWORD (required)
#   DB_NAME    - database to create (required)
#   DB_USER    - login / database user to create (required)
#   DB_PWD     - password for DB_USER (required, must satisfy MSSQL password policy)
#   TIMEOUT    - seconds to wait for SQL Server (default 180)
set -euo pipefail

: "${CONTAINER:?}" "${SA_PWD:?}" "${DB_NAME:?}" "${DB_USER:?}" "${DB_PWD:?}"
TIMEOUT="${TIMEOUT:-180}"
SQLCMD=/opt/mssql-tools18/bin/sqlcmd

# -C: trust the self-signed server certificate; password via env, not argv
sqlcmd_as() { # <user> <password> [sqlcmd args...]
  local u="$1" p="$2"; shift 2
  docker exec -i -e SQLCMDPASSWORD="$p" "$CONTAINER" "$SQLCMD" -S localhost -U "$u" -C -b "$@"
}

echo "Waiting for SQL Server in '$CONTAINER' (up to ${TIMEOUT}s)..."
start=$(date +%s)
until sqlcmd_as sa "$SA_PWD" -Q "SELECT 1" >/dev/null 2>&1; do
  if [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null)" != "true" ]; then
    echo "::error::MSSQL container '$CONTAINER' is not running"
    docker logs --tail 50 "$CONTAINER" || true
    exit 1
  fi
  if [ $(( $(date +%s) - start )) -ge "$TIMEOUT" ]; then
    echo "::error::SQL Server in '$CONTAINER' did not accept connections within ${TIMEOUT}s"
    docker logs --tail 50 "$CONTAINER" || true
    exit 1
  fi
  sleep 3
done
echo "SQL Server is up after $(( $(date +%s) - start ))s"

echo "Creating database [$DB_NAME], login and user [$DB_USER]..."
# values go in as sqlcmd scripting variables $(DB)/$(USR)/$(UPWD); the heredoc is quoted so bash leaves them alone
sqlcmd_as sa "$SA_PWD" -v DB="$DB_NAME" USR="$DB_USER" UPWD="$DB_PWD" <<'SQL'
IF DB_ID(N'$(DB)') IS NULL CREATE DATABASE [$(DB)];
GO
IF SUSER_ID(N'$(USR)') IS NULL CREATE LOGIN [$(USR)] WITH PASSWORD = N'$(UPWD)', DEFAULT_DATABASE = [$(DB)];
GO
USE [$(DB)];
IF USER_ID(N'$(USR)') IS NULL CREATE USER [$(USR)] FOR LOGIN [$(USR)];
ALTER ROLE db_owner ADD MEMBER [$(USR)];
GO
SQL

echo "Verifying login as [$DB_USER]..."
OUT=$(sqlcmd_as "$DB_USER" "$DB_PWD" -d "$DB_NAME" -h -1 -W \
  -Q "SET NOCOUNT ON; SELECT DB_NAME() + ' ' + SUSER_SNAME() + ' db_owner=' + CAST(IS_MEMBER('db_owner') AS varchar(2))" 2>&1 || true)
echo "$OUT"
if ! echo "$OUT" | grep -q "^${DB_NAME} ${DB_USER} db_owner=1"; then
  echo "::error::User '$DB_USER' cannot connect to '$DB_NAME' as db_owner"
  exit 1
fi
echo "MSSQL is ready: database '$DB_NAME', user '$DB_USER'"
