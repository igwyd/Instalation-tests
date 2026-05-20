# ONLYOFFICE Docs — Installation Tests

Automated installation testing of ONLYOFFICE Docs packages via GitHub Actions.

## Develop **<!-- onlyoffice-version-start -->v9.4.0-129<!-- onlyoffice-version-end -->**

Pre-release builds from S3 dev repo.

### Package installation (18 runners at the same time)
- Install from **helpcenter guide** and run all tests (Scheduled every Wednesday at 14:00 UTC+3)

<!-- deb-status-start -->
[![dev-DEB-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml)

**x64** · 2026-05-20 15:33 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (0) | ❌ FAILED (1) |
| DE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (1) | ❌ FAILED (4) |
| CE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (0) | ❌ FAILED (1) |
| EE Release | ✅ OK | 9.4.0-129 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-129 | JWT: ✅ MATCH | ✅ OK (0) | ❌ FAILED (3) |

**arm64** · 2026-05-20 15:41 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (3) |
| DE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (4) |
| CE | ✅ OK | ✅ 9.4.0-129 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (1) |
| EE Release | ✅ OK | 9.4.0-129 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-129 | JWT: ✅ MATCH | ✅ OK (5) | ❌ FAILED (3) |
<!-- deb-status-end -->

<!-- rpm-status-start -->
[![dev-RPM-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml)

**x64** · 2026-05-20 16:06 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (7) |
| DE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (5) | ❌ FAILED (7) |
| CE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (6) |
| EE Release | ✅ OK | 9.4.0-129.el7 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-129.el7 | JWT: ✅ MATCH | ✅ OK (2) | ❌ FAILED (5) |

**arm64** · 2026-05-20 15:55 UTC
| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |
|---------|-------------|---------|---------|----------------|---------------|
| EE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (3) | ❌ FAILED (5) |
| DE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (4) | ❌ FAILED (10) |
| CE | ✅ OK | ✅ 9.4.0-129.el7 | SVC: ✅ OK | ✅ OK (2) | ❌ FAILED (5) |
| EE Release | ✅ OK | 9.4.0-129.el7 | JWT: ✅ YES | — | — |
| EE Upgrade | ✅ OK | ✅ 9.4.0-129.el7 | JWT: ✅ MATCH | ✅ OK (2) | ❌ FAILED (8) |
<!-- rpm-status-end -->

- Check installation **OneClickInstall** on supported OS **Package** and **Docker** (Scheduled every Wednesday at 14:00 UTC+3)

| OS | x64/arm64 |
|---|---|
| dev-OS (Ubuntu 22.04, Debian 12/13, CentOS 10, RHEL 8/9/10) | ![dev-OS](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-x64-arm64.yml/badge.svg?branch=main) |


### Docker installation (4 runners at the same time)
- Install dev Docker image and run all tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | x64/arm64 |
|------|-----------|
| dev-Docker-DEB (Ubuntu 24.04) | [![dev-Docker-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-DEB-x64-arm64.yml) |
| dev-Docker-RPM (CentOS 9) | [![dev-Docker-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-RPM-x64-arm64.yml) |


### Server checks (1 runner at the same time)
- Install dev Docker image with server tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | Status |
|------|--------|
| dev-SERVER-checks | [![dev-SERVER-checks](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SERVER-checks.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SERVER-checks.yml) |


### Backend tests (14 runners at the same time)
* redis (Scheduled every Wednesday at 17:00 UTC+3)

| Test | Status |
|------|--------|
| dev-Redis-unix.sock (redis + ioredis) | [![dev-Redis](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml) |


* Tests with different DBs (Scheduled every Wednesday at 17:00 UTC+3)

<!-- db-status-start -->
| [![dev-DB-check](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml) | Healthcheck | Version | Puppeteer | DS Log Errors |
|-------|-------------|---------|-----------|---------------|
| MySQL | ✅ OK | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ❌ 2 |
| PostgreSQL | ✅ OK | ✅ 9.4.0-129 | ✅ 1 (API: 0, WOPI: 1) | ❌ 4 |
| PostgreSQL 14 | ✅ OK | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ❌ 2 |
| PostgreSQL 15 | ✅ OK | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ❌ 2 |
| PostgreSQL 16 | ✅ OK | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ❌ 1 |
| PostgreSQL 17 | ✅ OK | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ✅ 0 |
| MSSQL | ✅ OK | ✅ 9.4.0-129 | ✅ 1 (API: 0, WOPI: 1) | ❌ 1 |
| Oracle | ✅ OK | ✅ 9.4.0-129 | ✅ 1 (API: 1, WOPI: 0) | ❌ 3 |
| Dameng | ✅ OK | ✅ 9.4.0-129 | ✅ 1 (API: 1, WOPI: 0) | ❌ 3 |
| MariaDB | ✅ OK | ✅ 9.4.0-129 | ✅ 1 (API: 0, WOPI: 1) | ❌ 3 |
<!-- db-status-end -->

* Tests with ActiveMQ-Classic and ActiveMQ-Artemis (Scheduled every Wednesday at 17:00 UTC+3)

<!-- activemq-status-start -->
| [![dev-ActiveMQ](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml) | Healthcheck | Version | Puppeteer | DS Log Errors |
|-------|-------------|---------|-----------|---------------|
| Artemis | ❌ FAILED | ✅ 9.4.0-129 | ✅ 2 (API: 1, WOPI: 1) | ❌ 4 errors |
| Classic | ❌ FAILED | ✅ 9.4.0-129 | ✅ 0 (API: 0, WOPI: 0) | ❌ 3 errors |
<!-- activemq-status-end -->


## Release

Official public repos. Triggered manually via `workflow_dispatch`.

### Package installation

| Test | x64/arm64 |
|------|-----|
| release-DEB (Ubuntu 24.04) | [![release-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-x64-arm64.yml) |
| release-RPM (CentOS 9) | [![release-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-x64-arm64.yml) |

### Docker

| Test | x64/arm64 |
|------|-----------|
| release-Docker-DEB | [![release-Docker-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-x64-arm64.yml) |
| release-Docker-RPM | [![release-Docker-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-RPM-x64-arm64.yml) |

## Other

| Test | Status |
|------|--------|
| Compile from source | [![compile](https://github.com/igwyd/Instalation-tests/actions/workflows/Compile.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/Compile.yml) |
