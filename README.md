# ONLYOFFICE Docs — Installation Tests

Automated installation testing of ONLYOFFICE Docs packages via GitHub Actions.

## Develop **<!-- onlyoffice-version-start -->v9.4.0-115<!-- onlyoffice-version-end -->**

Pre-release builds from S3 dev repo.

### Package installation (18 runners at the same time)
- Install from **helpcenter guide** and run all tests (Scheduled every Wednesday at 14:00 UTC+3)

<!-- deb-status-start -->
[![dev-DEB-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml)

**x64** · 2026-05-08 12:56 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (1) |
| DE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (3) |
| CE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (2) |
| EE Release | ✅ OK | 9.3.1-10 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-76 | JWT: ✅ MATCH | ✅ OK (2) | ❌ FAILED (2) |

**arm64** · 2026-05-08 13:01 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (4) | ❌ FAILED (2) |
| DE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (4) | ❌ FAILED (6) |
| CE | ✅ OK | ✅ 9.4.0-76 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (4) |
| EE Release | ✅ OK | 9.3.1-10 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-76 | JWT: ✅ MATCH | ✅ OK (2) | ❌ FAILED (8) |
<!-- deb-status-end -->

<!-- rpm-status-start -->
[![dev-RPM-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml)

**x64** · 2026-05-08 13:24 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-76.el7 | SVC: ✅ OK | ✅ OK (5) | ❌ FAILED (13) |
| DE | ✅ OK | ✅ 9.4.0-76.el7 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (2) |
| CE | ✅ OK | ✅ 9.4.0-76.el7 | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (2) |
| EE Release | ✅ OK | 9.3.1-10.el7 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-76.el7 | JWT: ✅ MATCH | ✅ OK (3) | ❌ FAILED (1) |

**arm64** · 2026-05-08 13:11 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ❌ FAILED | ❌ ? | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (12) |
| DE | ✅ OK | ✅ 9.4.0-76.el7 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (5) |
| CE | ✅ OK | ✅ 9.4.0-76.el7 | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (3) |
| EE Release | ✅ OK | 9.3.1-10.el7 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-76.el7 | JWT: ✅ MATCH | ✅ OK (2) | ❌ FAILED (4) |
<!-- rpm-status-end -->

- Check installation **OneClickInstall** on supported OS **Package** and **Docker** (Scheduled every Wednesday at 14:00 UTC+3)

| OS | x64/arm64 |
|---|---|
| dev-OS (Ubuntu 22.04, Debian 12/13, CentOS 10, RHEL 8/9/10) | ![dev-OS](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-x64-arm64.yml/badge.svg?branch=main) |


### Docker installation (4 runners at the same time)
- Install dev Docker image and run all tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | x64/arm64 |
|------|-----------|
| dev-Docker-DEB (Ubuntu 24.04) | ![dev-Docker-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-DEB-x64-arm64.yml/badge.svg?branch=main) |
| dev-Docker-RPM (CentOS 9) | ![dev-Docker-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-RPM-x64-arm64.yml/badge.svg?branch=main) |


### Server checks (1 runner at the same time)
- Install dev Docker image with server tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | Status |
|------|--------|
| dev-SERVER-checks | ![dev-SERVER-checks](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SERVER-checks.yml/badge.svg?branch=main) |


### Backend tests (14 runners at the same time)
* redis (Scheduled every Wednesday at 17:00 UTC+3)

| Test | Status |
|------|--------|
| dev-Redis-unix.sock (redis + ioredis) | ![dev-Redis](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml/badge.svg?branch=main) |


* Tests with different DBs (Scheduled every Wednesday at 17:00 UTC+3)

<!-- db-status-start -->
| [![dev-DB-check](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml) | Healthcheck | Version | Puppeteer | DS Log Errors |
|-------|-------------|---------|-----------|---------------|
| MySQL | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 1 |
| PostgreSQL | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 3 |
| PostgreSQL 14 | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 1 |
| PostgreSQL 15 | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ✅ 0 |
| PostgreSQL 16 | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 3 |
| PostgreSQL 17 | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ✅ 0 |
| MSSQL | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ✅ 0 |
| Oracle | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 2 |
| Dameng | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 4 |
| MariaDB | ✅ OK | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 3 |
<!-- db-status-end -->

* Tests with ActiveMQ-Classic and ActiveMQ-Artemis (Scheduled every Wednesday at 17:00 UTC+3)

<!-- activemq-status-start -->
| [![dev-ActiveMQ](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml) | Healthcheck | Version | Puppeteer | DS Log Errors |
|-------|-------------|---------|-----------|---------------|
| Artemis | ❌ FAILED | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 2 errors |
| Classic | ❌ FAILED | ✅ 9.4.0-76 | ✅ 2 (API: 0, WOPI: 2) | ❌ 2 errors |
<!-- activemq-status-end -->


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
