# ONLYOFFICE Docs — Installation Tests

Automated installation testing of ONLYOFFICE Docs packages via GitHub Actions.

## Dev builds

Pre-release builds from S3 dev repo.

Tested version: **<!-- onlyoffice-version-start -->v9.4.0-11<!-- onlyoffice-version-end -->**

### Package installation
- Install from **helpcenter guide** and run all tests (Scheduled every Wednesday at 15:00 UTC+3)

| Test | x64 | arm64 |
|------|-----|-------|
| dev-DEB (Ubuntu 24.04) | ![dev-DEB-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64.yml/badge.svg?branch=main) | ![dev-DEB-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-arm64.yml/badge.svg?branch=main) |
| dev-RPM (CentOS 9) | ![dev-RPM-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64.yml/badge.svg?branch=main) | ![dev-RPM-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-arm64.yml/badge.svg?branch=main) |

- Check installation **OneClickInstall** on supported OS **Package** and **Docker** (Scheduled every Wednesday at 17:00 UTC+3)

| OS | x64/arm64 |
|---|---|
| dev-OS (Ubuntu 22.04) | ![ubuntu2204](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-ubuntu2204.yml/badge.svg?branch=main) |
| dev-OS (Debian 12) | ![debian12](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-debian12.yml/badge.svg?branch=main) |
| dev-OS (Debian 13) | ![debian13](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-debian13.yml/badge.svg?branch=main) |
| dev-OS (CentOS 10 stream) | ![centos10](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-centos10.yml/badge.svg?branch=main) |
| dev-OS (RHEL 9) | ![rhel9](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-rhel9.yml/badge.svg?branch=main) |
| dev-OS (RHEL 10) | ![rhel10](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-rhel10.yml/badge.svg?branch=main) |


### Backend tests

| Test | Status |
|------|--------|
| dev-Redis-unix.sock (redis + ioredis) | ![dev-Redis](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml/badge.svg?branch=main) |

### Databases

| Database | Status |
|----------|--------|
| dev-DB PostgreSQL | ![postgres](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-postgres.yml/badge.svg?branch=main) |
| dev-DB MySQL | ![mysql](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-mysql.yml/badge.svg?branch=main) |
| dev-DB MSSQL | ![mssql](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-mssql.yml/badge.svg?branch=main) |
| dev-DB Oracle | ![oracle](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-Oracle.yml/badge.svg?branch=main) |
| dev-DB Dameng | ![dameng](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-dameng.yml/badge.svg?branch=main) |


## Release

Official public repos. Triggered manually via `workflow_dispatch`.

### Package installation

| Test | x64 | arm64 |
|------|-----|-------|
| release-DEB (Ubuntu 24.04) | ![release-DEB-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-x64.yml/badge.svg?branch=main) | ![release-DEB-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-arm64.yml/badge.svg?branch=main) |
| release-RPM (CentOS 9) | ![release-RPM-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-x64.yml/badge.svg?branch=main) | ![release-RPM-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-arm64.yml/badge.svg?branch=main) |

### Docker

| Test | x64 | arm64 |
|------|-----|-------|
| release-Docker-DEB | ![docker-DEB-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-x64.yml/badge.svg?branch=main) | ![docker-DEB-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-arm64.yml/badge.svg?branch=main) |
| release-Docker-RPM | ![docker-RPM-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-RPM-x64.yml/badge.svg?branch=main) | |

## Other

| Test | Status |
|------|--------|
| Compile from source | ![compile](https://github.com/igwyd/Instalation-tests/actions/workflows/Compile.yml/badge.svg?branch=main) |
