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

# --- DS_VPATH ---
if [ "${HEALTHCHECK_DS_VPATH}" = "true" ]; then
  HC3_ICON="✅"; HC3_LABEL="OK";     HC3_DETAIL="${HEALTHCHECK_DS_VPATH}"
else
  HC3_ICON="❌"; HC3_LABEL="FAILED"; HC3_DETAIL="${HEALTHCHECK_DS_VPATH:-not set}"; FAILED=1
fi

if [ "${VERSION_DS_VPATH_OK}" = "true" ]; then
  VER3_ICON="✅"; VER3_LABEL="OK"
else
  VER3_ICON="❌"; VER3_LABEL="FAILED"; FAILED=1
fi
VER3_DETAIL="exp: ${EXPECTED}, act: ${VERSION_DS_VPATH_ACTUAL:-not set}"

PPT3_F="${PUPPETEER_DS_VPATH_FAILED:-0}"; PPT3_O="${PUPPETEER_DS_VPATH_OK:-0}"; PPT3_T="${PUPPETEER_DS_VPATH_TOTAL:-0}"
PPT3_DETAIL="${PPT3_O}/${PPT3_T} passed, ${PPT3_F} failed"
if [ "$PPT3_F" -gt 0 ] || [ "$PPT3_T" -eq 0 ]; then
  PPT3_ICON="❌"; PPT3_LABEL="FAILED"; FAILED=1
else
  PPT3_ICON="✅"; PPT3_LABEL="OK"
fi

DS3="${DS_LOG_ERRORS_DS_VPATH:-0}"
DS3_DETAIL="${DS3} errors"
if [ "$DS3" -gt 0 ]; then DS3_ICON="❌"; DS3_LABEL="FAILED"; else DS3_ICON="✅"; DS3_LABEL="OK"; fi

# --- AMQP_ARTEMIS ---
if [ "${HEALTHCHECK_AMQP_ARTEMIS}" = "true" ]; then
  HC4_ICON="✅"; HC4_LABEL="OK";     HC4_DETAIL="${HEALTHCHECK_AMQP_ARTEMIS}"
else
  HC4_ICON="❌"; HC4_LABEL="FAILED"; HC4_DETAIL="${HEALTHCHECK_AMQP_ARTEMIS:-not set}"; FAILED=1
fi

if [ "${VERSION_AMQP_ARTEMIS_OK}" = "true" ]; then
  VER4_ICON="✅"; VER4_LABEL="OK"
else
  VER4_ICON="❌"; VER4_LABEL="FAILED"; FAILED=1
fi
VER4_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AMQP_ARTEMIS_ACTUAL:-not set}"

PPT4_F="${PUPPETEER_AMQP_ARTEMIS_FAILED:-0}"; PPT4_O="${PUPPETEER_AMQP_ARTEMIS_OK:-0}"; PPT4_T="${PUPPETEER_AMQP_ARTEMIS_TOTAL:-0}"
PPT4_DETAIL="${PPT4_O}/${PPT4_T} passed, ${PPT4_F} failed"
if [ "$PPT4_F" -gt 0 ] || [ "$PPT4_T" -eq 0 ]; then
  PPT4_ICON="❌"; PPT4_LABEL="FAILED"; FAILED=1
else
  PPT4_ICON="✅"; PPT4_LABEL="OK"
fi

DS4="${DS_LOG_ERRORS_AMQP_ARTEMIS:-0}"
DS4_DETAIL="${DS4} errors"
if [ "$DS4" -gt 0 ]; then DS4_ICON="❌"; DS4_LABEL="FAILED"; else DS4_ICON="✅"; DS4_LABEL="OK"; fi

# --- AMQP_CLASSIC ---
if [ "${HEALTHCHECK_AMQP_CLASSIC}" = "true" ]; then
  HC5_ICON="✅"; HC5_LABEL="OK";     HC5_DETAIL="${HEALTHCHECK_AMQP_CLASSIC}"
else
  HC5_ICON="❌"; HC5_LABEL="FAILED"; HC5_DETAIL="${HEALTHCHECK_AMQP_CLASSIC:-not set}"; FAILED=1
fi

if [ "${VERSION_AMQP_CLASSIC_OK}" = "true" ]; then
  VER5_ICON="✅"; VER5_LABEL="OK"
else
  VER5_ICON="❌"; VER5_LABEL="FAILED"; FAILED=1
fi
VER5_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AMQP_CLASSIC_ACTUAL:-not set}"

PPT5_F="${PUPPETEER_AMQP_CLASSIC_FAILED:-0}"; PPT5_O="${PUPPETEER_AMQP_CLASSIC_OK:-0}"; PPT5_T="${PUPPETEER_AMQP_CLASSIC_TOTAL:-0}"
PPT5_DETAIL="${PPT5_O}/${PPT5_T} passed, ${PPT5_F} failed"
if [ "$PPT5_F" -gt 0 ] || [ "$PPT5_T" -eq 0 ]; then
  PPT5_ICON="❌"; PPT5_LABEL="FAILED"; FAILED=1
else
  PPT5_ICON="✅"; PPT5_LABEL="OK"
fi

DS5="${DS_LOG_ERRORS_AMQP_CLASSIC:-0}"
DS5_DETAIL="${DS5} errors"
if [ "$DS5" -gt 0 ]; then DS5_ICON="❌"; DS5_LABEL="FAILED"; else DS5_ICON="✅"; DS5_LABEL="OK"; fi

# --- REDIS_REDIS ---
if [ "${HEALTHCHECK_REDIS_REDIS}" = "true" ]; then
  HC6_ICON="✅"; HC6_LABEL="OK";     HC6_DETAIL="${HEALTHCHECK_REDIS_REDIS}"
else
  HC6_ICON="❌"; HC6_LABEL="FAILED"; HC6_DETAIL="${HEALTHCHECK_REDIS_REDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_REDIS_OK}" = "true" ]; then
  VER6_ICON="✅"; VER6_LABEL="OK"
else
  VER6_ICON="❌"; VER6_LABEL="FAILED"; FAILED=1
fi
VER6_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_REDIS_ACTUAL:-not set}"

if [ "${REDIS_SOCK_OK_REDIS_REDIS}" = "true" ]; then
  SOCK6_ICON="✅"; SOCK6_LABEL="OK"
else
  SOCK6_ICON="❌"; SOCK6_LABEL="FAILED"; FAILED=1
fi
SOCK6_DETAIL="PONG: ${REDIS_SOCK_OK_REDIS_REDIS:-not set}"

if [ "${PORT_6379_CLOSED_REDIS_REDIS}" = "true" ]; then
  PORT6_ICON="✅"; PORT6_LABEL="OK"
else
  PORT6_ICON="❌"; PORT6_LABEL="FAILED"; FAILED=1
fi
PORT6_DETAIL="closed: ${PORT_6379_CLOSED_REDIS_REDIS:-not set}"

PPT6_F="${PUPPETEER_REDIS_REDIS_FAILED:-0}"; PPT6_O="${PUPPETEER_REDIS_REDIS_OK:-0}"; PPT6_T="${PUPPETEER_REDIS_REDIS_TOTAL:-0}"
PPT6_DETAIL="${PPT6_O}/${PPT6_T} passed, ${PPT6_F} failed"
if [ "$PPT6_F" -gt 0 ] || [ "$PPT6_T" -eq 0 ]; then
  PPT6_ICON="❌"; PPT6_LABEL="FAILED"; FAILED=1
else
  PPT6_ICON="✅"; PPT6_LABEL="OK"
fi

DS6="${DS_LOG_ERRORS_REDIS_REDIS:-0}"
DS6_DETAIL="${DS6} errors"
if [ "$DS6" -gt 0 ]; then DS6_ICON="❌"; DS6_LABEL="FAILED"; else DS6_ICON="✅"; DS6_LABEL="OK"; fi

# --- REDIS_IOREDIS ---
if [ "${HEALTHCHECK_REDIS_IOREDIS}" = "true" ]; then
  HC7_ICON="✅"; HC7_LABEL="OK";     HC7_DETAIL="${HEALTHCHECK_REDIS_IOREDIS}"
else
  HC7_ICON="❌"; HC7_LABEL="FAILED"; HC7_DETAIL="${HEALTHCHECK_REDIS_IOREDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_IOREDIS_OK}" = "true" ]; then
  VER7_ICON="✅"; VER7_LABEL="OK"
else
  VER7_ICON="❌"; VER7_LABEL="FAILED"; FAILED=1
fi
VER7_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_IOREDIS_ACTUAL:-not set}"

if [ "${REDIS_SOCK_OK_REDIS_IOREDIS}" = "true" ]; then
  SOCK7_ICON="✅"; SOCK7_LABEL="OK"
else
  SOCK7_ICON="❌"; SOCK7_LABEL="FAILED"; FAILED=1
fi
SOCK7_DETAIL="PONG: ${REDIS_SOCK_OK_REDIS_IOREDIS:-not set}"

if [ "${PORT_6379_CLOSED_REDIS_IOREDIS}" = "true" ]; then
  PORT7_ICON="✅"; PORT7_LABEL="OK"
else
  PORT7_ICON="❌"; PORT7_LABEL="FAILED"; FAILED=1
fi
PORT7_DETAIL="closed: ${PORT_6379_CLOSED_REDIS_IOREDIS:-not set}"

PPT7_F="${PUPPETEER_REDIS_IOREDIS_FAILED:-0}"; PPT7_O="${PUPPETEER_REDIS_IOREDIS_OK:-0}"; PPT7_T="${PUPPETEER_REDIS_IOREDIS_TOTAL:-0}"
PPT7_DETAIL="${PPT7_O}/${PPT7_T} passed, ${PPT7_F} failed"
if [ "$PPT7_F" -gt 0 ] || [ "$PPT7_T" -eq 0 ]; then
  PPT7_ICON="❌"; PPT7_LABEL="FAILED"; FAILED=1
else
  PPT7_ICON="✅"; PPT7_LABEL="OK"
fi

DS7="${DS_LOG_ERRORS_REDIS_IOREDIS:-0}"
DS7_DETAIL="${DS7} errors"
if [ "$DS7" -gt 0 ]; then DS7_ICON="❌"; DS7_LABEL="FAILED"; else DS7_ICON="✅"; DS7_LABEL="OK"; fi

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
  echo "### Virtual Path"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC3_ICON} ${HC3_LABEL}  | ${HC3_DETAIL} |"
  echo "| Version       | ${VER3_ICON} ${VER3_LABEL} | \`${VERSION_DS_VPATH_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT3_ICON} ${PPT3_LABEL} | ${PPT3_DETAIL} |"
  echo "| DS Log Errors | ${DS3_DETAIL} | |"
  echo ""
  echo "### ActiveMQ Artemis"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC4_ICON} ${HC4_LABEL}  | ${HC4_DETAIL} |"
  echo "| Version       | ${VER4_ICON} ${VER4_LABEL} | \`${VERSION_AMQP_ARTEMIS_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT4_ICON} ${PPT4_LABEL} | ${PPT4_DETAIL} |"
  echo "| DS Log Errors | ${DS4_DETAIL} | |"
  echo ""
  echo "### ActiveMQ Classic"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC5_ICON} ${HC5_LABEL}  | ${HC5_DETAIL} |"
  echo "| Version       | ${VER5_ICON} ${VER5_LABEL} | \`${VERSION_AMQP_CLASSIC_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT5_ICON} ${PPT5_LABEL} | ${PPT5_DETAIL} |"
  echo "| DS Log Errors | ${DS5_DETAIL} | |"
  echo ""
  echo "### Redis unix.sock (redis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck     | ${HC6_ICON} ${HC6_LABEL}  | ${HC6_DETAIL} |"
  echo "| Version         | ${VER6_ICON} ${VER6_LABEL} | \`${VERSION_REDIS_REDIS_ACTUAL:-not set}\` |"
  echo "| Redis sock ping | ${SOCK6_ICON} ${SOCK6_LABEL} | ${SOCK6_DETAIL} |"
  echo "| Port 6379       | ${PORT6_ICON} ${PORT6_LABEL} | ${PORT6_DETAIL} |"
  echo "| Puppeteer       | ${PPT6_ICON} ${PPT6_LABEL} | ${PPT6_DETAIL} |"
  echo "| DS Log Errors   | ${DS6_DETAIL} | |"
  echo ""
  echo "### Redis unix.sock (ioredis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck     | ${HC7_ICON} ${HC7_LABEL}  | ${HC7_DETAIL} |"
  echo "| Version         | ${VER7_ICON} ${VER7_LABEL} | \`${VERSION_REDIS_IOREDIS_ACTUAL:-not set}\` |"
  echo "| Redis sock ping | ${SOCK7_ICON} ${SOCK7_LABEL} | ${SOCK7_DETAIL} |"
  echo "| Port 6379       | ${PORT7_ICON} ${PORT7_LABEL} | ${PORT7_DETAIL} |"
  echo "| Puppeteer       | ${PPT7_ICON} ${PPT7_LABEL} | ${PPT7_DETAIL} |"
  echo "| DS Log Errors   | ${DS7_DETAIL} | |"
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
echo ""
echo "=== Virtual Path ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC3_LABEL}"  "${HC3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER3_LABEL}" "${VER3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT3_LABEL}" "${PPT3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS3_DETAIL}"
echo "$SEP"
echo ""
echo "=== ActiveMQ Artemis ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC4_LABEL}"  "${HC4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER4_LABEL}" "${VER4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT4_LABEL}" "${PPT4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS4_DETAIL}"
echo "$SEP"
echo ""
echo "=== ActiveMQ Classic ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC5_LABEL}"  "${HC5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER5_LABEL}" "${VER5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT5_LABEL}" "${PPT5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS5_DETAIL}"
echo "$SEP"
echo ""
echo "=== Redis unix.sock (redis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"     "${HC6_LABEL}"   "${HC6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"         "${VER6_LABEL}"  "${VER6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Redis sock ping" "${SOCK6_LABEL}" "${SOCK6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Port 6379"       "${PORT6_LABEL}" "${PORT6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"       "${PPT6_LABEL}"  "${PPT6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"   ""   "${DS6_DETAIL}"
echo "$SEP"
echo ""
echo "=== Redis unix.sock (ioredis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"     "${HC7_LABEL}"   "${HC7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"         "${VER7_LABEL}"  "${VER7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Redis sock ping" "${SOCK7_LABEL}" "${SOCK7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Port 6379"       "${PORT7_LABEL}" "${PORT7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"       "${PPT7_LABEL}"  "${PPT7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"   ""   "${DS7_DETAIL}"
echo "$SEP"

if [ "$FAILED" -eq 1 ]; then
  echo "FINAL_CONCLUSION=failure" >> "$GITHUB_ENV"
  exit 1
else
  echo "FINAL_CONCLUSION=success" >> "$GITHUB_ENV"
fi
