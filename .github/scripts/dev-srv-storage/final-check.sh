#!/bin/bash
set -e

FAILED=0
EXPECTED="${EXPECTED_VERSION}"

# --- AWS_S3_FALSE ---
if [ "${HEALTHCHECK_AWS_S3_FALSE}" = "true" ]; then
  HC1_ICON="✅"; HC1_LABEL="OK";     HC1_DETAIL="${HEALTHCHECK_AWS_S3_FALSE}"
else
  HC1_ICON="❌"; HC1_LABEL="FAILED"; HC1_DETAIL="${HEALTHCHECK_AWS_S3_FALSE:-not set}"; FAILED=1
fi

if [ "${VERSION_AWS_S3_FALSE_OK}" = "true" ]; then
  VER1_ICON="✅"; VER1_LABEL="OK"
else
  VER1_ICON="❌"; VER1_LABEL="FAILED"; FAILED=1
fi
VER1_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AWS_S3_FALSE_ACTUAL:-not set}"

PPT1_F="${PUPPETEER_AWS_S3_FALSE_FAILED:-0}"; PPT1_O="${PUPPETEER_AWS_S3_FALSE_OK:-0}"; PPT1_T="${PUPPETEER_AWS_S3_FALSE_TOTAL:-0}"
PPT1_DETAIL="${PPT1_O}/${PPT1_T} passed, ${PPT1_F} failed"
if [ "$PPT1_F" -gt 0 ] || [ "$PPT1_T" -eq 0 ]; then
  PPT1_ICON="❌"; PPT1_LABEL="FAILED"; FAILED=1
else
  PPT1_ICON="✅"; PPT1_LABEL="OK"
fi

DS1="${DS_LOG_ERRORS_AWS_S3_FALSE:-0}"
DS1_DETAIL="${DS1} errors"
if [ "$DS1" -gt 0 ]; then DS1_ICON="❌"; DS1_LABEL="FAILED"; else DS1_ICON="✅"; DS1_LABEL="OK"; fi

# --- AWS_S3_TRUE ---
if [ "${HEALTHCHECK_AWS_S3_TRUE}" = "true" ]; then
  HC2_ICON="✅"; HC2_LABEL="OK";     HC2_DETAIL="${HEALTHCHECK_AWS_S3_TRUE}"
else
  HC2_ICON="❌"; HC2_LABEL="FAILED"; HC2_DETAIL="${HEALTHCHECK_AWS_S3_TRUE:-not set}"; FAILED=1
fi

if [ "${VERSION_AWS_S3_TRUE_OK}" = "true" ]; then
  VER2_ICON="✅"; VER2_LABEL="OK"
else
  VER2_ICON="❌"; VER2_LABEL="FAILED"; FAILED=1
fi
VER2_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AWS_S3_TRUE_ACTUAL:-not set}"

PPT2_F="${PUPPETEER_AWS_S3_TRUE_FAILED:-0}"; PPT2_O="${PUPPETEER_AWS_S3_TRUE_OK:-0}"; PPT2_T="${PUPPETEER_AWS_S3_TRUE_TOTAL:-0}"
PPT2_DETAIL="${PPT2_O}/${PPT2_T} passed, ${PPT2_F} failed"
if [ "$PPT2_F" -gt 0 ] || [ "$PPT2_T" -eq 0 ]; then
  PPT2_ICON="❌"; PPT2_LABEL="FAILED"; FAILED=1
else
  PPT2_ICON="✅"; PPT2_LABEL="OK"
fi

DS2="${DS_LOG_ERRORS_AWS_S3_TRUE:-0}"
DS2_DETAIL="${DS2} errors"
if [ "$DS2" -gt 0 ]; then DS2_ICON="❌"; DS2_LABEL="FAILED"; else DS2_ICON="✅"; DS2_LABEL="OK"; fi

# --- AWS_S3_PATH_STYLE ---
if [ "${HEALTHCHECK_AWS_S3_PATH_STYLE}" = "true" ]; then
  HC8_ICON="✅"; HC8_LABEL="OK";     HC8_DETAIL="${HEALTHCHECK_AWS_S3_PATH_STYLE}"
else
  HC8_ICON="❌"; HC8_LABEL="FAILED"; HC8_DETAIL="${HEALTHCHECK_AWS_S3_PATH_STYLE:-not set}"; FAILED=1
fi

if [ "${VERSION_AWS_S3_PATH_STYLE_OK}" = "true" ]; then
  VER8_ICON="✅"; VER8_LABEL="OK"
else
  VER8_ICON="❌"; VER8_LABEL="FAILED"; FAILED=1
fi
VER8_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AWS_S3_PATH_STYLE_ACTUAL:-not set}"

PPT8_F="${PUPPETEER_AWS_S3_PATH_STYLE_FAILED:-0}"; PPT8_O="${PUPPETEER_AWS_S3_PATH_STYLE_OK:-0}"; PPT8_T="${PUPPETEER_AWS_S3_PATH_STYLE_TOTAL:-0}"
PPT8_DETAIL="${PPT8_O}/${PPT8_T} passed, ${PPT8_F} failed"
if [ "$PPT8_F" -gt 0 ] || [ "$PPT8_T" -eq 0 ]; then
  PPT8_ICON="❌"; PPT8_LABEL="FAILED"; FAILED=1
else
  PPT8_ICON="✅"; PPT8_LABEL="OK"
fi

DS8="${DS_LOG_ERRORS_AWS_S3_PATH_STYLE:-0}"
DS8_DETAIL="${DS8} errors"
if [ "$DS8" -gt 0 ]; then DS8_ICON="❌"; DS8_LABEL="FAILED"; else DS8_ICON="✅"; DS8_LABEL="OK"; fi

# --- AWS_S3_KMS ---
if [ "${HEALTHCHECK_AWS_S3_KMS}" = "true" ]; then
  HC9_ICON="✅"; HC9_LABEL="OK";     HC9_DETAIL="${HEALTHCHECK_AWS_S3_KMS}"
else
  HC9_ICON="❌"; HC9_LABEL="FAILED"; HC9_DETAIL="${HEALTHCHECK_AWS_S3_KMS:-not set}"; FAILED=1
fi

if [ "${VERSION_AWS_S3_KMS_OK}" = "true" ]; then
  VER9_ICON="✅"; VER9_LABEL="OK"
else
  VER9_ICON="❌"; VER9_LABEL="FAILED"; FAILED=1
fi
VER9_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AWS_S3_KMS_ACTUAL:-not set}"

PPT9_F="${PUPPETEER_AWS_S3_KMS_FAILED:-0}"; PPT9_O="${PUPPETEER_AWS_S3_KMS_OK:-0}"; PPT9_T="${PUPPETEER_AWS_S3_KMS_TOTAL:-0}"
PPT9_DETAIL="${PPT9_O}/${PPT9_T} passed, ${PPT9_F} failed"
if [ "$PPT9_F" -gt 0 ] || [ "$PPT9_T" -eq 0 ]; then
  PPT9_ICON="❌"; PPT9_LABEL="FAILED"; FAILED=1
else
  PPT9_ICON="✅"; PPT9_LABEL="OK"
fi

DS9="${DS_LOG_ERRORS_AWS_S3_KMS:-0}"
DS9_DETAIL="${DS9} errors"
if [ "$DS9" -gt 0 ]; then DS9_ICON="❌"; DS9_LABEL="FAILED"; else DS9_ICON="✅"; DS9_LABEL="OK"; fi

# --- MINIO_HTTP_FALSE ---
if [ "${HEALTHCHECK_MINIO_HTTP_FALSE}" = "true" ]; then
  HC13_ICON="✅"; HC13_LABEL="OK";     HC13_DETAIL="${HEALTHCHECK_MINIO_HTTP_FALSE}"
else
  HC13_ICON="❌"; HC13_LABEL="FAILED"; HC13_DETAIL="${HEALTHCHECK_MINIO_HTTP_FALSE:-not set}"; FAILED=1
fi

if [ "${VERSION_MINIO_HTTP_FALSE_OK}" = "true" ]; then
  VER13_ICON="✅"; VER13_LABEL="OK"
else
  VER13_ICON="❌"; VER13_LABEL="FAILED"; FAILED=1
fi
VER13_DETAIL="exp: ${EXPECTED}, act: ${VERSION_MINIO_HTTP_FALSE_ACTUAL:-not set}"

PPT13_F="${PUPPETEER_MINIO_HTTP_FALSE_FAILED:-0}"; PPT13_O="${PUPPETEER_MINIO_HTTP_FALSE_OK:-0}"; PPT13_T="${PUPPETEER_MINIO_HTTP_FALSE_TOTAL:-0}"
PPT13_DETAIL="${PPT13_O}/${PPT13_T} passed, ${PPT13_F} failed"
if [ "$PPT13_F" -gt 0 ] || [ "$PPT13_T" -eq 0 ]; then
  PPT13_ICON="❌"; PPT13_LABEL="FAILED"; FAILED=1
else
  PPT13_ICON="✅"; PPT13_LABEL="OK"
fi

DS13="${DS_LOG_ERRORS_MINIO_HTTP_FALSE:-0}"
DS13_DETAIL="${DS13} errors"
if [ "$DS13" -gt 0 ]; then DS13_ICON="❌"; DS13_LABEL="FAILED"; else DS13_ICON="✅"; DS13_LABEL="OK"; fi

# --- MINIO_HTTP_TRUE ---
if [ "${HEALTHCHECK_MINIO_HTTP_TRUE}" = "true" ]; then
  HC14_ICON="✅"; HC14_LABEL="OK";     HC14_DETAIL="${HEALTHCHECK_MINIO_HTTP_TRUE}"
else
  HC14_ICON="❌"; HC14_LABEL="FAILED"; HC14_DETAIL="${HEALTHCHECK_MINIO_HTTP_TRUE:-not set}"; FAILED=1
fi

if [ "${VERSION_MINIO_HTTP_TRUE_OK}" = "true" ]; then
  VER14_ICON="✅"; VER14_LABEL="OK"
else
  VER14_ICON="❌"; VER14_LABEL="FAILED"; FAILED=1
fi
VER14_DETAIL="exp: ${EXPECTED}, act: ${VERSION_MINIO_HTTP_TRUE_ACTUAL:-not set}"

PPT14_F="${PUPPETEER_MINIO_HTTP_TRUE_FAILED:-0}"; PPT14_O="${PUPPETEER_MINIO_HTTP_TRUE_OK:-0}"; PPT14_T="${PUPPETEER_MINIO_HTTP_TRUE_TOTAL:-0}"
PPT14_DETAIL="${PPT14_O}/${PPT14_T} passed, ${PPT14_F} failed"
if [ "$PPT14_F" -gt 0 ] || [ "$PPT14_T" -eq 0 ]; then
  PPT14_ICON="❌"; PPT14_LABEL="FAILED"; FAILED=1
else
  PPT14_ICON="✅"; PPT14_LABEL="OK"
fi

DS14="${DS_LOG_ERRORS_MINIO_HTTP_TRUE:-0}"
DS14_DETAIL="${DS14} errors"
if [ "$DS14" -gt 0 ]; then DS14_ICON="❌"; DS14_LABEL="FAILED"; else DS14_ICON="✅"; DS14_LABEL="OK"; fi

# --- MINIO_HTTP_PATH_STYLE ---
if [ "${HEALTHCHECK_MINIO_HTTP_PATH_STYLE}" = "true" ]; then
  HC15_ICON="✅"; HC15_LABEL="OK";     HC15_DETAIL="${HEALTHCHECK_MINIO_HTTP_PATH_STYLE}"
else
  HC15_ICON="❌"; HC15_LABEL="FAILED"; HC15_DETAIL="${HEALTHCHECK_MINIO_HTTP_PATH_STYLE:-not set}"; FAILED=1
fi

if [ "${VERSION_MINIO_HTTP_PATH_STYLE_OK}" = "true" ]; then
  VER15_ICON="✅"; VER15_LABEL="OK"
else
  VER15_ICON="❌"; VER15_LABEL="FAILED"; FAILED=1
fi
VER15_DETAIL="exp: ${EXPECTED}, act: ${VERSION_MINIO_HTTP_PATH_STYLE_ACTUAL:-not set}"

PPT15_F="${PUPPETEER_MINIO_HTTP_PATH_STYLE_FAILED:-0}"; PPT15_O="${PUPPETEER_MINIO_HTTP_PATH_STYLE_OK:-0}"; PPT15_T="${PUPPETEER_MINIO_HTTP_PATH_STYLE_TOTAL:-0}"
PPT15_DETAIL="${PPT15_O}/${PPT15_T} passed, ${PPT15_F} failed"
if [ "$PPT15_F" -gt 0 ] || [ "$PPT15_T" -eq 0 ]; then
  PPT15_ICON="❌"; PPT15_LABEL="FAILED"; FAILED=1
else
  PPT15_ICON="✅"; PPT15_LABEL="OK"
fi

DS15="${DS_LOG_ERRORS_MINIO_HTTP_PATH_STYLE:-0}"
DS15_DETAIL="${DS15} errors"
if [ "$DS15" -gt 0 ]; then DS15_ICON="❌"; DS15_LABEL="FAILED"; else DS15_ICON="✅"; DS15_LABEL="OK"; fi

# --- AZURE_STORAGE_DIRECTURL_FALSE ---
if [ "${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_FALSE}" = "true" ]; then
  HC10_ICON="✅"; HC10_LABEL="OK";     HC10_DETAIL="${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_FALSE}"
else
  HC10_ICON="❌"; HC10_LABEL="FAILED"; HC10_DETAIL="${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_FALSE:-not set}"; FAILED=1
fi

if [ "${VERSION_AZURE_STORAGE_DIRECTURL_FALSE_OK}" = "true" ]; then
  VER10_ICON="✅"; VER10_LABEL="OK"
else
  VER10_ICON="❌"; VER10_LABEL="FAILED"; FAILED=1
fi
VER10_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AZURE_STORAGE_DIRECTURL_FALSE_ACTUAL:-not set}"

PPT10_F="${PUPPETEER_AZURE_STORAGE_DIRECTURL_FALSE_FAILED:-0}"; PPT10_O="${PUPPETEER_AZURE_STORAGE_DIRECTURL_FALSE_OK:-0}"; PPT10_T="${PUPPETEER_AZURE_STORAGE_DIRECTURL_FALSE_TOTAL:-0}"
PPT10_DETAIL="${PPT10_O}/${PPT10_T} passed, ${PPT10_F} failed"
if [ "$PPT10_F" -gt 0 ] || [ "$PPT10_T" -eq 0 ]; then
  PPT10_ICON="❌"; PPT10_LABEL="FAILED"; FAILED=1
else
  PPT10_ICON="✅"; PPT10_LABEL="OK"
fi

DS10="${DS_LOG_ERRORS_AZURE_STORAGE_DIRECTURL_FALSE:-0}"
DS10_DETAIL="${DS10} errors"
if [ "$DS10" -gt 0 ]; then DS10_ICON="❌"; DS10_LABEL="FAILED"; else DS10_ICON="✅"; DS10_LABEL="OK"; fi

# --- AZURE_STORAGE_DIRECTURL_TRUE ---
if [ "${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_TRUE}" = "true" ]; then
  HC11_ICON="✅"; HC11_LABEL="OK";     HC11_DETAIL="${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_TRUE}"
else
  HC11_ICON="❌"; HC11_LABEL="FAILED"; HC11_DETAIL="${HEALTHCHECK_AZURE_STORAGE_DIRECTURL_TRUE:-not set}"; FAILED=1
fi

if [ "${VERSION_AZURE_STORAGE_DIRECTURL_TRUE_OK}" = "true" ]; then
  VER11_ICON="✅"; VER11_LABEL="OK"
else
  VER11_ICON="❌"; VER11_LABEL="FAILED"; FAILED=1
fi
VER11_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AZURE_STORAGE_DIRECTURL_TRUE_ACTUAL:-not set}"

PPT11_F="${PUPPETEER_AZURE_STORAGE_DIRECTURL_TRUE_FAILED:-0}"; PPT11_O="${PUPPETEER_AZURE_STORAGE_DIRECTURL_TRUE_OK:-0}"; PPT11_T="${PUPPETEER_AZURE_STORAGE_DIRECTURL_TRUE_TOTAL:-0}"
PPT11_DETAIL="${PPT11_O}/${PPT11_T} passed, ${PPT11_F} failed"
if [ "$PPT11_F" -gt 0 ] || [ "$PPT11_T" -eq 0 ]; then
  PPT11_ICON="❌"; PPT11_LABEL="FAILED"; FAILED=1
else
  PPT11_ICON="✅"; PPT11_LABEL="OK"
fi

DS11="${DS_LOG_ERRORS_AZURE_STORAGE_DIRECTURL_TRUE:-0}"
DS11_DETAIL="${DS11} errors"
if [ "$DS11" -gt 0 ]; then DS11_ICON="❌"; DS11_LABEL="FAILED"; else DS11_ICON="✅"; DS11_LABEL="OK"; fi

# --- AZURE_STORAGE_ENCRYPTION_SCOPE ---
if [ "${HEALTHCHECK_AZURE_STORAGE_ENCRYPTION_SCOPE}" = "true" ]; then
  HC12_ICON="✅"; HC12_LABEL="OK";     HC12_DETAIL="${HEALTHCHECK_AZURE_STORAGE_ENCRYPTION_SCOPE}"
else
  HC12_ICON="❌"; HC12_LABEL="FAILED"; HC12_DETAIL="${HEALTHCHECK_AZURE_STORAGE_ENCRYPTION_SCOPE:-not set}"; FAILED=1
fi

if [ "${VERSION_AZURE_STORAGE_ENCRYPTION_SCOPE_OK}" = "true" ]; then
  VER12_ICON="✅"; VER12_LABEL="OK"
else
  VER12_ICON="❌"; VER12_LABEL="FAILED"; FAILED=1
fi
VER12_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AZURE_STORAGE_ENCRYPTION_SCOPE_ACTUAL:-not set}"

PPT12_F="${PUPPETEER_AZURE_STORAGE_ENCRYPTION_SCOPE_FAILED:-0}"; PPT12_O="${PUPPETEER_AZURE_STORAGE_ENCRYPTION_SCOPE_OK:-0}"; PPT12_T="${PUPPETEER_AZURE_STORAGE_ENCRYPTION_SCOPE_TOTAL:-0}"
PPT12_DETAIL="${PPT12_O}/${PPT12_T} passed, ${PPT12_F} failed"
if [ "$PPT12_F" -gt 0 ] || [ "$PPT12_T" -eq 0 ]; then
  PPT12_ICON="❌"; PPT12_LABEL="FAILED"; FAILED=1
else
  PPT12_ICON="✅"; PPT12_LABEL="OK"
fi

DS12="${DS_LOG_ERRORS_AZURE_STORAGE_ENCRYPTION_SCOPE:-0}"
DS12_DETAIL="${DS12} errors"
if [ "$DS12" -gt 0 ]; then DS12_ICON="❌"; DS12_LABEL="FAILED"; else DS12_ICON="✅"; DS12_LABEL="OK"; fi

# --- GITHUB_STEP_SUMMARY (markdown table) ---
{
  echo "## Final Check"
  echo ""
  echo "### S3 useDirectStorageUrls=false"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC1_ICON} ${HC1_LABEL}  | ${HC1_DETAIL} |"
  echo "| Version       | ${VER1_ICON} ${VER1_LABEL} | \`${VERSION_AWS_S3_FALSE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT1_ICON} ${PPT1_LABEL} | ${PPT1_DETAIL} |"
  echo "| DS Log Errors | ${DS1_DETAIL} | |"
  echo ""
  echo "### S3 useDirectStorageUrls=true"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC2_ICON} ${HC2_LABEL}  | ${HC2_DETAIL} |"
  echo "| Version       | ${VER2_ICON} ${VER2_LABEL} | \`${VERSION_AWS_S3_TRUE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT2_ICON} ${PPT2_LABEL} | ${PPT2_DETAIL} |"
  echo "| DS Log Errors | ${DS2_DETAIL} | |"
  echo ""
  echo "### S3 s3ForcePathStyle=true"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC8_ICON} ${HC8_LABEL}  | ${HC8_DETAIL} |"
  echo "| Version       | ${VER8_ICON} ${VER8_LABEL} | \`${VERSION_AWS_S3_PATH_STYLE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT8_ICON} ${PPT8_LABEL} | ${PPT8_DETAIL} |"
  echo "| DS Log Errors | ${DS8_DETAIL} | |"
  echo ""
  echo "### S3 AWS KMS"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC9_ICON} ${HC9_LABEL}  | ${HC9_DETAIL} |"
  echo "| Version       | ${VER9_ICON} ${VER9_LABEL} | \`${VERSION_AWS_S3_KMS_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT9_ICON} ${PPT9_LABEL} | ${PPT9_DETAIL} |"
  echo "| DS Log Errors | ${DS9_DETAIL} | |"
  echo ""
  echo "### MinIO HTTP useDirectStorageUrls=false"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC13_ICON} ${HC13_LABEL}  | ${HC13_DETAIL} |"
  echo "| Version       | ${VER13_ICON} ${VER13_LABEL} | \`${VERSION_MINIO_HTTP_FALSE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT13_ICON} ${PPT13_LABEL} | ${PPT13_DETAIL} |"
  echo "| DS Log Errors | ${DS13_DETAIL} | |"
  echo ""
  echo "### MinIO HTTP useDirectStorageUrls=true"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC14_ICON} ${HC14_LABEL}  | ${HC14_DETAIL} |"
  echo "| Version       | ${VER14_ICON} ${VER14_LABEL} | \`${VERSION_MINIO_HTTP_TRUE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT14_ICON} ${PPT14_LABEL} | ${PPT14_DETAIL} |"
  echo "| DS Log Errors | ${DS14_DETAIL} | |"
  echo ""
  echo "### MinIO HTTP s3ForcePathStyle=true"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC15_ICON} ${HC15_LABEL}  | ${HC15_DETAIL} |"
  echo "| Version       | ${VER15_ICON} ${VER15_LABEL} | \`${VERSION_MINIO_HTTP_PATH_STYLE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT15_ICON} ${PPT15_LABEL} | ${PPT15_DETAIL} |"
  echo "| DS Log Errors | ${DS15_DETAIL} | |"
  echo ""
  echo "### Azure Blob Storage useDirectStorageUrls=false"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC10_ICON} ${HC10_LABEL}  | ${HC10_DETAIL} |"
  echo "| Version       | ${VER10_ICON} ${VER10_LABEL} | \`${VERSION_AZURE_STORAGE_DIRECTURL_FALSE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT10_ICON} ${PPT10_LABEL} | ${PPT10_DETAIL} |"
  echo "| DS Log Errors | ${DS10_DETAIL} | |"
  echo ""
  echo "### Azure Blob Storage useDirectStorageUrls=true"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC11_ICON} ${HC11_LABEL}  | ${HC11_DETAIL} |"
  echo "| Version       | ${VER11_ICON} ${VER11_LABEL} | \`${VERSION_AZURE_STORAGE_DIRECTURL_TRUE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT11_ICON} ${PPT11_LABEL} | ${PPT11_DETAIL} |"
  echo "| DS Log Errors | ${DS11_DETAIL} | |"
  echo ""
  echo "### Azure Blob Storage encryptionScope"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC12_ICON} ${HC12_LABEL}  | ${HC12_DETAIL} |"
  echo "| Version       | ${VER12_ICON} ${VER12_LABEL} | \`${VERSION_AZURE_STORAGE_ENCRYPTION_SCOPE_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT12_ICON} ${PPT12_LABEL} | ${PPT12_DETAIL} |"
  echo "| DS Log Errors | ${DS12_DETAIL} | |"
  echo ""
  if [ "$FAILED" -eq 1 ]; then
    echo "> ❌ **Final check FAILED**"
  else
    echo "> ✅ **All checks passed**"
  fi
} >> "$GITHUB_STEP_SUMMARY"

# --- Console log (ASCII table) ---
SEP="+----------------------+--------+--------------------------------------------+"
echo "=== S3 useDirectStorageUrls=false ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC1_LABEL}"  "${HC1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER1_LABEL}" "${VER1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT1_LABEL}" "${PPT1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS1_DETAIL}"
echo "$SEP"
echo ""
echo "=== S3 useDirectStorageUrls=true ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC2_LABEL}"  "${HC2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER2_LABEL}" "${VER2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT2_LABEL}" "${PPT2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS2_DETAIL}"
echo "$SEP"
echo ""
echo "=== S3 s3ForcePathStyle=true ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC8_LABEL}"  "${HC8_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER8_LABEL}" "${VER8_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT8_LABEL}" "${PPT8_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS8_DETAIL}"
echo "$SEP"
echo ""
echo "=== S3 AWS KMS ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC9_LABEL}"  "${HC9_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER9_LABEL}" "${VER9_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT9_LABEL}" "${PPT9_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS9_DETAIL}"
echo "$SEP"
echo ""
echo "=== MinIO HTTP useDirectStorageUrls=false ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC13_LABEL}"  "${HC13_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER13_LABEL}" "${VER13_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT13_LABEL}" "${PPT13_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS13_DETAIL}"
echo "$SEP"
echo ""
echo "=== MinIO HTTP useDirectStorageUrls=true ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC14_LABEL}"  "${HC14_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER14_LABEL}" "${VER14_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT14_LABEL}" "${PPT14_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS14_DETAIL}"
echo "$SEP"
echo ""
echo "=== MinIO HTTP s3ForcePathStyle=true ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC15_LABEL}"  "${HC15_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER15_LABEL}" "${VER15_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT15_LABEL}" "${PPT15_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS15_DETAIL}"
echo "$SEP"
echo ""
echo "=== Azure Blob Storage useDirectStorageUrls=false ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC10_LABEL}"  "${HC10_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER10_LABEL}" "${VER10_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT10_LABEL}" "${PPT10_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS10_DETAIL}"
echo "$SEP"
echo ""
echo "=== Azure Blob Storage useDirectStorageUrls=true ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC11_LABEL}"  "${HC11_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER11_LABEL}" "${VER11_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT11_LABEL}" "${PPT11_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS11_DETAIL}"
echo "$SEP"
echo ""
echo "=== Azure Blob Storage encryptionScope ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC12_LABEL}"  "${HC12_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER12_LABEL}" "${VER12_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT12_LABEL}" "${PPT12_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS12_DETAIL}"
echo "$SEP"

if [ "$FAILED" -eq 1 ]; then
  echo "FINAL_CONCLUSION=failure" >> "$GITHUB_ENV"
  exit 1
else
  echo "FINAL_CONCLUSION=success" >> "$GITHUB_ENV"
fi
