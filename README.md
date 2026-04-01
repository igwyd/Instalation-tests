# ONLYOFFICE Docs — Installation Tests

Automated installation testing of ONLYOFFICE Docs packages via GitHub Actions.

## Develop (tested version: **<!-- onlyoffice-version-start -->v9.4.0-40<!-- onlyoffice-version-end -->**)

Pre-release builds from S3 dev repo.

### Package installation
- Install from **helpcenter guide** and run all tests (Scheduled every Wednesday at 15:00 UTC+3)

| Test | x64/arm64 |
|------|-----|
| dev-DEB (Ubuntu 24.04) | ![dev-DEB-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main) | ![dev-DEB-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main) |
| dev-RPM (CentOS 9) | ![dev-RPM-x64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml/badge.svg?branch=main) |

- Check installation **OneClickInstall** on supported OS **Package** and **Docker** (Scheduled every Wednesday at 17:00 UTC+3)

| OS | x64/arm64 |
|---|---|
| dev-OS (Ubuntu 22.04, Debian 12/13, CentOS 10, RHEL 9/10) | ![dev-OS](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-x64-arm64.yml/badge.svg?branch=main) |


### Backend tests
* redis (Scheduled every Wednesday at 15:00 UTC+3)

| Test | Status |
|------|--------|
| dev-Redis-unix.sock (redis + ioredis) | ![dev-Redis](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml/badge.svg?branch=main) |


* Tests with different DBs (Scheduled every Wednesday at 15:00 UTC+3)

| Test | Status |
|------|--------|
| MySQL, PostgreSQL, MSSQL, Oracle, Dameng, MariaDB | ![dev-DB-check](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml/badge.svg?branch=main) |

* Tests with ActiveMQ-Classic and ActiveMQ-Artemis

| Test | Status |
|------|--------|
| dev-ActiveMQ Classic and Artemis | ![dev-ActiveMQ](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml/badge.svg?branch=main) |


## Release

Official public repos. Triggered manually via `workflow_dispatch`.

### Package installation

| Test | x64/arm64 |
|------|-----|
| release-DEB (Ubuntu 24.04) | ![release-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-x64-arm64.yml/badge.svg?branch=main) |
| release-RPM (CentOS 9) | ![release-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-x64-arm64.yml/badge.svg?branch=main) |

### Docker

| Test | x64/arm64 |
|------|-----------|
| release-Docker-DEB | ![release-Docker-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-x64-arm64.yml/badge.svg?branch=main) |
| release-Docker-RPM | ![release-Docker-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-RPM-x64-arm64.yml/badge.svg?branch=main) |

## Other

| Test | Status |
|------|--------|
| Compile from source | ![compile](https://github.com/igwyd/Instalation-tests/actions/workflows/Compile.yml/badge.svg?branch=main) |
