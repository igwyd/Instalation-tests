# Installation tests
ONLYOFFICE-Docs installation checks
## Develop
### DEB installation, install from manual (Scheduled every wednesday at 15:00 UTC+3)
Tested version **<!-- onlyoffice-version-start -->v9.3.0-15<!-- onlyoffice-version-end -->** \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-arm64.yml/badge.svg?branch=main)  
### RPM installation, install from manual (Scheduled every wednesday at 15:00 UTC+3)
Tested version **<!-- onlyoffice-version-start -->v9.3.0-15<!-- onlyoffice-version-end -->** \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-x64.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-RPM-arm64.yml/badge.svg?branch=main)  
### Test connection to Redis via unix.sock (div-proxy)
Tested version **<!-- onlyoffice-version-start -->v9.3.0-15<!-- onlyoffice-version-end -->** \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-Redis-unix.sock.yml/badge.svg?branch=main)  
### Load tests with DataBases (Scheduled every wednesday at 15:00 UTC+3)
Tested version **<!-- onlyoffice-version-start -->v9.3.0-15<!-- onlyoffice-version-end -->** \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-Oracle.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-mysql.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-mssql.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-postgres.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-dameng.yml/badge.svg?branch=main)  
## Release
### Check DEB version in current release repo, installation guide from helpcenter 
Test DEB package installation ONLYOFFICE-Docs EE, DE and CE from released repo. \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-x64.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-DEB-arm64.yml/badge.svg?branch=main)
### Check RPM version in current release repo, installation guide from helpcenter  
Test RPM package installation ONLYOFFICE-Docs EE, DE and CE from released repo. \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-x64.yml/badge.svg?branch=main)  
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-RPM-arm64.yml/badge.svg?branch=main)  
### Check Docker version current release
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-x64.yml/badge.svg?branch=main) \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-RPM-x64.yml/badge.svg?branch=main) \
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/release-Docker-DEB-arm64.yml/badge.svg?branch=main) 
## Common
### Compile from source
![GitHub Actions Status](https://github.com/igwyd/Instalation-tests/actions/workflows/Compile.yml/badge.svg?branch=main)  