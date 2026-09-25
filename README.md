# ONLYOFFICE Docs — Installation Tests

Automated installation testing of ONLYOFFICE Docs packages via GitHub Actions.

📊 **[Test Results Dashboard](https://d2a3vv866b8brc.cloudfront.net/)** — detailed results for all dev builds

## Weekly schedule

Everything is scheduled on **Wednesday**. Jobs = GitHub-hosted runners the slot occupies at once
(matrix entries), so the peak is 18 at 11:00 UTC.

| UTC | UTC+3 | Workflow | Jobs |
|-----|--------|----------|------|
| 07:30 | 10:30 Wed | Update version in README | 1 |
| 11:00 | 14:00 Wed | dev-DEB | 2 |
| 11:00 | 14:00 Wed | dev-RPM | 2 |
| 11:00 | 14:00 Wed | dev-OS | 14 |
| 13:00 | 16:00 Wed | dev-Docker-DEB | 2 |
| 13:00 | 16:00 Wed | dev-Docker-RPM | 2 |
| 13:00 | 16:00 Wed | dev-SRV-storage | 1 |
| 13:00 | 16:00 Wed | dev-SRV-dependances | 1 |
| 13:00 | 16:00 Wed | dev-TLS-dependencies | 1 |
| 14:00 | 17:00 Wed | dev-DB-check | 10 |
| 20:00 | 23:00 Wed | Deploy Dashboard | 1 |
| 21:30 | 00:30 Thu | Deploy Weekly Snapshot | 1 |

Concurrency limit for GitHub-hosted Linux runners is per account plan — 20 on Free, 40 on Pro,
60 on Team, 500 on Enterprise. Jobs over the limit are queued, not dropped. The 11:00 slot uses
18 of them, and its runs are long enough to still be busy at 13:00 (18 + 7 = 25), so on the Free
plan part of the 13:00 slot waits in the queue.

## Develop **<!-- onlyoffice-version-start -->v10.0.0-105<!-- onlyoffice-version-end -->**

Pre-release builds from S3 dev repo.

### Package installation (18 runners at the same time)
- Install from **helpcenter guide** and run all tests (Scheduled every Wednesday at 14:00 UTC+3)

| Test | x64/arm64 |
|------|-----------|
| dev-DEB (Ubuntu 24.04) | [![dev-DEB-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml) |
| dev-RPM (CentOS 9) | [![dev-RPM-x64-arm64](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64-arm64.yml) |
| dev-OS (Ubuntu 26.04, Debian 12/13, CentOS 10, RHEL 8/9/10) | [![dev-OS](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-OS-x64-arm64.yml) |


### Docker installation (4 runners at the same time)
- Install dev Docker image and run all tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | x64/arm64 |
|------|-----------|
| dev-Docker-DEB (Ubuntu 24.04) | [![dev-Docker-DEB](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-DEB-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-DEB-x64-arm64.yml) |
| dev-Docker-RPM (CentOS 9) | [![dev-Docker-RPM](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-RPM-x64-arm64.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Docker-RPM-x64-arm64.yml) |


### Server checks (3 runners at the same time)
- dev Docker image with server tests (Scheduled every Wednesday at 16:00 UTC+3)

| Test | Status |
|------|--------|
| dev-SRV-storage (S3, MinIO, Azure) | [![dev-SRV-storage](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SRV-storage.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SRV-storage.yml) |
| dev-SRV-dependances (Virtual Path, ActiveMQ, Redis) | [![dev-SRV-dependances](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SRV-dependances.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-SRV-dependances.yml) |
| dev-TLS-dependencies | [![dev-TLS-dependencies](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-TLS-dependencies.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-TLS-dependencies.yml) |


### Backend tests (10 runners at the same time)
- dev Docker images with differnet DB's (Scheduled every Wednesday at 17:00 UTC+3)

| Test | Status |
|------|--------|
| dev-DB-check (MySQL, PostgreSQL, MSSQL, Oracle, Dameng, MariaDB) | [![dev-DB-check](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml) |


### ONLYOFFICE Apps install (up to 17 runners, manual)
- Install dev Docs, check the `/welcome` "Install apps" modal, install ONLYOFFICE Apps (4testing) on top of it and open a document from Apps in this Docs. Triggered manually via `workflow_dispatch` (`cases`: `all` or case numbers, e.g. `1,7`). EC2 instances are left running for manual checks — re-run with `cleanup=true` to terminate them.

| Test | Status |
|------|--------|
| dev-APPS-install | [![dev-APPS-install](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-APPS-install.yml/badge.svg?branch=main)](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-APPS-install.yml) |

Cases 1–12: within each method every architecture gets all three editions and all three Docs ports; both methods together cover all 9 edition × port pairs. Port 8888 stands in for "any custom port" (8080 is among the ports Apps needs itself).

| # | Method | OS | Arch | Docs edition | Docs port | Docs HTTPS |
|---|--------|----|------|--------------|-----------|------------|
| 1 | package | Ubuntu 24.04 | x64 | EE | 80 | — |
| 2 | package | Debian 13 | x64 | DE | 8083 | — |
| 3 | package | RHEL 9 | x64 | CE | 8888 | — |
| 4 | package | Ubuntu 26.04 | arm64 | DE | 80 | — |
| 5 | package | CentOS 10 | arm64 | CE | 8083 | — |
| 6 | package | RHEL 10 | arm64 | EE | 8888 | — |
| 7 | docker | CentOS 9 | x64 | EE | 8083 | — |
| 8 | docker | Debian 12 | x64 | DE | 8888 | — |
| 9 | docker | RHEL 10 | x64 | CE | 80 | — |
| 10 | docker | Ubuntu 26.04 | arm64 | CE | 8083 | — |
| 11 | docker | RHEL 9 | arm64 | EE | 80 | — |
| 12 | docker | Ubuntu 24.04 | arm64 | DE | 8888 | — |
| 13 | package | RHEL 9 | arm64 | EE | 80 + 443 | self-signed |
| 14 | package | Debian 13 | x64 | DE | 80 + 443 | wildcard `*.div.qa-onlyoffice.net` |
| 15 | docker | Debian 12 | x64 | CE | 80 + 443 | wildcard `*.div.qa-onlyoffice.net` |
| 16 | docker | Ubuntu 24.04 | arm64 | DE | 80 + 443 | Let's Encrypt |
| 17 | package | RHEL 10 | x64 | CE | 80 + 443 | Let's Encrypt |

Cases 13–17: Docs already serves HTTPS on 443 for `apps-<case>-<run>.qa-onlyoffice.net` (`.div.qa-onlyoffice.net` for the wildcard cases; an A record created in Route53 for the run) and Apps must take the certificate over: Apps serves 443 with the same certificate, redirects HTTP to HTTPS and moves Docs to plain HTTP behind itself. The Let's Encrypt cases also check that renewal is handed over to Apps.


## Release

Official public repos. Triggered manually via `workflow_dispatch`.

### Package installation

| Test | x64/arm64 |
|------|-----------|
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
