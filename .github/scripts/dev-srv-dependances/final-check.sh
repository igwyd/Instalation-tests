#!/bin/bash
set -e

FAILED=0
EXPECTED="${EXPECTED_VERSION}"

# --- DS_VPATH ---
if [ "${HEALTHCHECK_DS_VPATH}" = "true" ]; then
  HC1_ICON="✅"; HC1_LABEL="OK";     HC1_DETAIL="${HEALTHCHECK_DS_VPATH}"
else
  HC1_ICON="❌"; HC1_LABEL="FAILED"; HC1_DETAIL="${HEALTHCHECK_DS_VPATH:-not set}"; FAILED=1
fi

if [ "${VERSION_DS_VPATH_OK}" = "true" ]; then
  VER1_ICON="✅"; VER1_LABEL="OK"
else
  VER1_ICON="❌"; VER1_LABEL="FAILED"; FAILED=1
fi
VER1_DETAIL="exp: ${EXPECTED}, act: ${VERSION_DS_VPATH_ACTUAL:-not set}"

PPT1_F="${PUPPETEER_DS_VPATH_FAILED:-0}"; PPT1_O="${PUPPETEER_DS_VPATH_OK:-0}"; PPT1_T="${PUPPETEER_DS_VPATH_TOTAL:-0}"
PPT1_DETAIL="${PPT1_O}/${PPT1_T} passed, ${PPT1_F} failed"
if [ "$PPT1_F" -gt 0 ] || [ "$PPT1_T" -eq 0 ]; then
  PPT1_ICON="❌"; PPT1_LABEL="FAILED"; FAILED=1
else
  PPT1_ICON="✅"; PPT1_LABEL="OK"
fi

DS1="${DS_LOG_ERRORS_DS_VPATH:-0}"
DS1_DETAIL="${DS1} errors"
if [ "$DS1" -gt 0 ]; then DS1_ICON="❌"; DS1_LABEL="FAILED"; else DS1_ICON="✅"; DS1_LABEL="OK"; fi

# --- AMQP_ARTEMIS ---
if [ "${HEALTHCHECK_AMQP_ARTEMIS}" = "true" ]; then
  HC2_ICON="✅"; HC2_LABEL="OK";     HC2_DETAIL="${HEALTHCHECK_AMQP_ARTEMIS}"
else
  HC2_ICON="❌"; HC2_LABEL="FAILED"; HC2_DETAIL="${HEALTHCHECK_AMQP_ARTEMIS:-not set}"; FAILED=1
fi

if [ "${VERSION_AMQP_ARTEMIS_OK}" = "true" ]; then
  VER2_ICON="✅"; VER2_LABEL="OK"
else
  VER2_ICON="❌"; VER2_LABEL="FAILED"; FAILED=1
fi
VER2_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AMQP_ARTEMIS_ACTUAL:-not set}"

PPT2_F="${PUPPETEER_AMQP_ARTEMIS_FAILED:-0}"; PPT2_O="${PUPPETEER_AMQP_ARTEMIS_OK:-0}"; PPT2_T="${PUPPETEER_AMQP_ARTEMIS_TOTAL:-0}"
PPT2_DETAIL="${PPT2_O}/${PPT2_T} passed, ${PPT2_F} failed"
if [ "$PPT2_F" -gt 0 ] || [ "$PPT2_T" -eq 0 ]; then
  PPT2_ICON="❌"; PPT2_LABEL="FAILED"; FAILED=1
else
  PPT2_ICON="✅"; PPT2_LABEL="OK"
fi

DS2="${DS_LOG_ERRORS_AMQP_ARTEMIS:-0}"
DS2_DETAIL="${DS2} errors"
if [ "$DS2" -gt 0 ]; then DS2_ICON="❌"; DS2_LABEL="FAILED"; else DS2_ICON="✅"; DS2_LABEL="OK"; fi

# --- AMQP_CLASSIC ---
if [ "${HEALTHCHECK_AMQP_CLASSIC}" = "true" ]; then
  HC3_ICON="✅"; HC3_LABEL="OK";     HC3_DETAIL="${HEALTHCHECK_AMQP_CLASSIC}"
else
  HC3_ICON="❌"; HC3_LABEL="FAILED"; HC3_DETAIL="${HEALTHCHECK_AMQP_CLASSIC:-not set}"; FAILED=1
fi

if [ "${VERSION_AMQP_CLASSIC_OK}" = "true" ]; then
  VER3_ICON="✅"; VER3_LABEL="OK"
else
  VER3_ICON="❌"; VER3_LABEL="FAILED"; FAILED=1
fi
VER3_DETAIL="exp: ${EXPECTED}, act: ${VERSION_AMQP_CLASSIC_ACTUAL:-not set}"

PPT3_F="${PUPPETEER_AMQP_CLASSIC_FAILED:-0}"; PPT3_O="${PUPPETEER_AMQP_CLASSIC_OK:-0}"; PPT3_T="${PUPPETEER_AMQP_CLASSIC_TOTAL:-0}"
PPT3_DETAIL="${PPT3_O}/${PPT3_T} passed, ${PPT3_F} failed"
if [ "$PPT3_F" -gt 0 ] || [ "$PPT3_T" -eq 0 ]; then
  PPT3_ICON="❌"; PPT3_LABEL="FAILED"; FAILED=1
else
  PPT3_ICON="✅"; PPT3_LABEL="OK"
fi

DS3="${DS_LOG_ERRORS_AMQP_CLASSIC:-0}"
DS3_DETAIL="${DS3} errors"
if [ "$DS3" -gt 0 ]; then DS3_ICON="❌"; DS3_LABEL="FAILED"; else DS3_ICON="✅"; DS3_LABEL="OK"; fi

# --- REDIS_REDIS ---
if [ "${HEALTHCHECK_REDIS_REDIS}" = "true" ]; then
  HC4_ICON="✅"; HC4_LABEL="OK";     HC4_DETAIL="${HEALTHCHECK_REDIS_REDIS}"
else
  HC4_ICON="❌"; HC4_LABEL="FAILED"; HC4_DETAIL="${HEALTHCHECK_REDIS_REDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_REDIS_OK}" = "true" ]; then
  VER4_ICON="✅"; VER4_LABEL="OK"
else
  VER4_ICON="❌"; VER4_LABEL="FAILED"; FAILED=1
fi
VER4_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_REDIS_ACTUAL:-not set}"

if [ "${REDIS_SOCK_OK_REDIS_REDIS}" = "true" ]; then
  SOCK4_ICON="✅"; SOCK4_LABEL="OK"
else
  SOCK4_ICON="❌"; SOCK4_LABEL="FAILED"; FAILED=1
fi
SOCK4_DETAIL="PONG: ${REDIS_SOCK_OK_REDIS_REDIS:-not set}"

if [ "${PORT_6379_CLOSED_REDIS_REDIS}" = "true" ]; then
  PORT4_ICON="✅"; PORT4_LABEL="OK"
else
  PORT4_ICON="❌"; PORT4_LABEL="FAILED"; FAILED=1
fi
PORT4_DETAIL="closed: ${PORT_6379_CLOSED_REDIS_REDIS:-not set}"

PPT4_F="${PUPPETEER_REDIS_REDIS_FAILED:-0}"; PPT4_O="${PUPPETEER_REDIS_REDIS_OK:-0}"; PPT4_T="${PUPPETEER_REDIS_REDIS_TOTAL:-0}"
PPT4_DETAIL="${PPT4_O}/${PPT4_T} passed, ${PPT4_F} failed"
if [ "$PPT4_F" -gt 0 ] || [ "$PPT4_T" -eq 0 ]; then
  PPT4_ICON="❌"; PPT4_LABEL="FAILED"; FAILED=1
else
  PPT4_ICON="✅"; PPT4_LABEL="OK"
fi

DS4="${DS_LOG_ERRORS_REDIS_REDIS:-0}"
DS4_DETAIL="${DS4} errors"
if [ "$DS4" -gt 0 ]; then DS4_ICON="❌"; DS4_LABEL="FAILED"; else DS4_ICON="✅"; DS4_LABEL="OK"; fi

# --- REDIS_IOREDIS ---
if [ "${HEALTHCHECK_REDIS_IOREDIS}" = "true" ]; then
  HC5_ICON="✅"; HC5_LABEL="OK";     HC5_DETAIL="${HEALTHCHECK_REDIS_IOREDIS}"
else
  HC5_ICON="❌"; HC5_LABEL="FAILED"; HC5_DETAIL="${HEALTHCHECK_REDIS_IOREDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_IOREDIS_OK}" = "true" ]; then
  VER5_ICON="✅"; VER5_LABEL="OK"
else
  VER5_ICON="❌"; VER5_LABEL="FAILED"; FAILED=1
fi
VER5_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_IOREDIS_ACTUAL:-not set}"

if [ "${REDIS_SOCK_OK_REDIS_IOREDIS}" = "true" ]; then
  SOCK5_ICON="✅"; SOCK5_LABEL="OK"
else
  SOCK5_ICON="❌"; SOCK5_LABEL="FAILED"; FAILED=1
fi
SOCK5_DETAIL="PONG: ${REDIS_SOCK_OK_REDIS_IOREDIS:-not set}"

if [ "${PORT_6379_CLOSED_REDIS_IOREDIS}" = "true" ]; then
  PORT5_ICON="✅"; PORT5_LABEL="OK"
else
  PORT5_ICON="❌"; PORT5_LABEL="FAILED"; FAILED=1
fi
PORT5_DETAIL="closed: ${PORT_6379_CLOSED_REDIS_IOREDIS:-not set}"

PPT5_F="${PUPPETEER_REDIS_IOREDIS_FAILED:-0}"; PPT5_O="${PUPPETEER_REDIS_IOREDIS_OK:-0}"; PPT5_T="${PUPPETEER_REDIS_IOREDIS_TOTAL:-0}"
PPT5_DETAIL="${PPT5_O}/${PPT5_T} passed, ${PPT5_F} failed"
if [ "$PPT5_F" -gt 0 ] || [ "$PPT5_T" -eq 0 ]; then
  PPT5_ICON="❌"; PPT5_LABEL="FAILED"; FAILED=1
else
  PPT5_ICON="✅"; PPT5_LABEL="OK"
fi

DS5="${DS_LOG_ERRORS_REDIS_IOREDIS:-0}"
DS5_DETAIL="${DS5} errors"
if [ "$DS5" -gt 0 ]; then DS5_ICON="❌"; DS5_LABEL="FAILED"; else DS5_ICON="✅"; DS5_LABEL="OK"; fi

# --- REDIS_CLUSTER_REDIS ---
if [ "${HEALTHCHECK_REDIS_CLUSTER_REDIS}" = "true" ]; then
  HC6_ICON="✅"; HC6_LABEL="OK";     HC6_DETAIL="${HEALTHCHECK_REDIS_CLUSTER_REDIS}"
else
  HC6_ICON="❌"; HC6_LABEL="FAILED"; HC6_DETAIL="${HEALTHCHECK_REDIS_CLUSTER_REDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_CLUSTER_REDIS_OK}" = "true" ]; then
  VER6_ICON="✅"; VER6_LABEL="OK"
else
  VER6_ICON="❌"; VER6_LABEL="FAILED"; FAILED=1
fi
VER6_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_CLUSTER_REDIS_ACTUAL:-not set}"

if [ "${CLUSTER_OK_REDIS_CLUSTER_REDIS}" = "true" ]; then
  CL6_ICON="✅"; CL6_LABEL="OK"
else
  CL6_ICON="❌"; CL6_LABEL="FAILED"; FAILED=1
fi
CL6_DETAIL="cluster_state:ok + DS connected: ${CLUSTER_OK_REDIS_CLUSTER_REDIS:-not set}"

if [ "${REDIS_LOCAL_STOPPED_REDIS_CLUSTER_REDIS}" = "true" ]; then
  LOC6_ICON="✅"; LOC6_LABEL="OK"
else
  LOC6_ICON="❌"; LOC6_LABEL="FAILED"; FAILED=1
fi
LOC6_DETAIL="built-in redis stopped: ${REDIS_LOCAL_STOPPED_REDIS_CLUSTER_REDIS:-not set}"

PPT6_F="${PUPPETEER_REDIS_CLUSTER_REDIS_FAILED:-0}"; PPT6_O="${PUPPETEER_REDIS_CLUSTER_REDIS_OK:-0}"; PPT6_T="${PUPPETEER_REDIS_CLUSTER_REDIS_TOTAL:-0}"
PPT6_DETAIL="${PPT6_O}/${PPT6_T} passed, ${PPT6_F} failed"
if [ "$PPT6_F" -gt 0 ] || [ "$PPT6_T" -eq 0 ]; then
  PPT6_ICON="❌"; PPT6_LABEL="FAILED"; FAILED=1
else
  PPT6_ICON="✅"; PPT6_LABEL="OK"
fi

DS6="${DS_LOG_ERRORS_REDIS_CLUSTER_REDIS:-0}"
DS6_DETAIL="${DS6} errors"
if [ "$DS6" -gt 0 ]; then DS6_ICON="❌"; DS6_LABEL="FAILED"; else DS6_ICON="✅"; DS6_LABEL="OK"; fi

# --- REDIS_CLUSTER_IOREDIS ---
if [ "${HEALTHCHECK_REDIS_CLUSTER_IOREDIS}" = "true" ]; then
  HC7_ICON="✅"; HC7_LABEL="OK";     HC7_DETAIL="${HEALTHCHECK_REDIS_CLUSTER_IOREDIS}"
else
  HC7_ICON="❌"; HC7_LABEL="FAILED"; HC7_DETAIL="${HEALTHCHECK_REDIS_CLUSTER_IOREDIS:-not set}"; FAILED=1
fi

if [ "${VERSION_REDIS_CLUSTER_IOREDIS_OK}" = "true" ]; then
  VER7_ICON="✅"; VER7_LABEL="OK"
else
  VER7_ICON="❌"; VER7_LABEL="FAILED"; FAILED=1
fi
VER7_DETAIL="exp: ${EXPECTED}, act: ${VERSION_REDIS_CLUSTER_IOREDIS_ACTUAL:-not set}"

if [ "${CLUSTER_OK_REDIS_CLUSTER_IOREDIS}" = "true" ]; then
  CL7_ICON="✅"; CL7_LABEL="OK"
else
  CL7_ICON="❌"; CL7_LABEL="FAILED"; FAILED=1
fi
CL7_DETAIL="cluster_state:ok + DS connected: ${CLUSTER_OK_REDIS_CLUSTER_IOREDIS:-not set}"

if [ "${REDIS_LOCAL_STOPPED_REDIS_CLUSTER_IOREDIS}" = "true" ]; then
  LOC7_ICON="✅"; LOC7_LABEL="OK"
else
  LOC7_ICON="❌"; LOC7_LABEL="FAILED"; FAILED=1
fi
LOC7_DETAIL="built-in redis stopped: ${REDIS_LOCAL_STOPPED_REDIS_CLUSTER_IOREDIS:-not set}"

PPT7_F="${PUPPETEER_REDIS_CLUSTER_IOREDIS_FAILED:-0}"; PPT7_O="${PUPPETEER_REDIS_CLUSTER_IOREDIS_OK:-0}"; PPT7_T="${PUPPETEER_REDIS_CLUSTER_IOREDIS_TOTAL:-0}"
PPT7_DETAIL="${PPT7_O}/${PPT7_T} passed, ${PPT7_F} failed"
if [ "$PPT7_F" -gt 0 ] || [ "$PPT7_T" -eq 0 ]; then
  PPT7_ICON="❌"; PPT7_LABEL="FAILED"; FAILED=1
else
  PPT7_ICON="✅"; PPT7_LABEL="OK"
fi

DS7="${DS_LOG_ERRORS_REDIS_CLUSTER_IOREDIS:-0}"
DS7_DETAIL="${DS7} errors"
if [ "$DS7" -gt 0 ]; then DS7_ICON="❌"; DS7_LABEL="FAILED"; else DS7_ICON="✅"; DS7_LABEL="OK"; fi

# --- GITHUB_STEP_SUMMARY (markdown table) ---
{
  echo "## Final Check"
  echo ""
  echo "### Virtual Path"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC1_ICON} ${HC1_LABEL}  | ${HC1_DETAIL} |"
  echo "| Version       | ${VER1_ICON} ${VER1_LABEL} | \`${VERSION_DS_VPATH_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT1_ICON} ${PPT1_LABEL} | ${PPT1_DETAIL} |"
  echo "| DS Log Errors | ${DS1_DETAIL} | |"
  echo ""
  echo "### ActiveMQ Artemis"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC2_ICON} ${HC2_LABEL}  | ${HC2_DETAIL} |"
  echo "| Version       | ${VER2_ICON} ${VER2_LABEL} | \`${VERSION_AMQP_ARTEMIS_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT2_ICON} ${PPT2_LABEL} | ${PPT2_DETAIL} |"
  echo "| DS Log Errors | ${DS2_DETAIL} | |"
  echo ""
  echo "### ActiveMQ Classic"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck   | ${HC3_ICON} ${HC3_LABEL}  | ${HC3_DETAIL} |"
  echo "| Version       | ${VER3_ICON} ${VER3_LABEL} | \`${VERSION_AMQP_CLASSIC_ACTUAL:-not set}\` |"
  echo "| Puppeteer     | ${PPT3_ICON} ${PPT3_LABEL} | ${PPT3_DETAIL} |"
  echo "| DS Log Errors | ${DS3_DETAIL} | |"
  echo ""
  echo "### Redis unix.sock (redis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck     | ${HC4_ICON} ${HC4_LABEL}  | ${HC4_DETAIL} |"
  echo "| Version         | ${VER4_ICON} ${VER4_LABEL} | \`${VERSION_REDIS_REDIS_ACTUAL:-not set}\` |"
  echo "| Redis sock ping | ${SOCK4_ICON} ${SOCK4_LABEL} | ${SOCK4_DETAIL} |"
  echo "| Port 6379       | ${PORT4_ICON} ${PORT4_LABEL} | ${PORT4_DETAIL} |"
  echo "| Puppeteer       | ${PPT4_ICON} ${PPT4_LABEL} | ${PPT4_DETAIL} |"
  echo "| DS Log Errors   | ${DS4_DETAIL} | |"
  echo ""
  echo "### Redis unix.sock (ioredis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck     | ${HC5_ICON} ${HC5_LABEL}  | ${HC5_DETAIL} |"
  echo "| Version         | ${VER5_ICON} ${VER5_LABEL} | \`${VERSION_REDIS_IOREDIS_ACTUAL:-not set}\` |"
  echo "| Redis sock ping | ${SOCK5_ICON} ${SOCK5_LABEL} | ${SOCK5_DETAIL} |"
  echo "| Port 6379       | ${PORT5_ICON} ${PORT5_LABEL} | ${PORT5_DETAIL} |"
  echo "| Puppeteer       | ${PPT5_ICON} ${PPT5_LABEL} | ${PPT5_DETAIL} |"
  echo "| DS Log Errors   | ${DS5_DETAIL} | |"
  echo ""
  echo "### Redis cluster (redis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck        | ${HC6_ICON} ${HC6_LABEL}  | ${HC6_DETAIL} |"
  echo "| Version            | ${VER6_ICON} ${VER6_LABEL} | \`${VERSION_REDIS_CLUSTER_REDIS_ACTUAL:-not set}\` |"
  echo "| Cluster connection | ${CL6_ICON} ${CL6_LABEL} | ${CL6_DETAIL} |"
  echo "| Built-in redis     | ${LOC6_ICON} ${LOC6_LABEL} | ${LOC6_DETAIL} |"
  echo "| Puppeteer          | ${PPT6_ICON} ${PPT6_LABEL} | ${PPT6_DETAIL} |"
  echo "| DS Log Errors      | ${DS6_DETAIL} | |"
  echo ""
  echo "### Redis cluster (ioredis driver)"
  echo ""
  echo "| Check | Result | Details |"
  echo "|-------|--------|---------|"
  echo "| Healthcheck        | ${HC7_ICON} ${HC7_LABEL}  | ${HC7_DETAIL} |"
  echo "| Version            | ${VER7_ICON} ${VER7_LABEL} | \`${VERSION_REDIS_CLUSTER_IOREDIS_ACTUAL:-not set}\` |"
  echo "| Cluster connection | ${CL7_ICON} ${CL7_LABEL} | ${CL7_DETAIL} |"
  echo "| Built-in redis     | ${LOC7_ICON} ${LOC7_LABEL} | ${LOC7_DETAIL} |"
  echo "| Puppeteer          | ${PPT7_ICON} ${PPT7_LABEL} | ${PPT7_DETAIL} |"
  echo "| DS Log Errors      | ${DS7_DETAIL} | |"
  echo ""
  if [ "$FAILED" -eq 1 ]; then
    echo "> ❌ **Final check FAILED**"
  else
    echo "> ✅ **All checks passed**"
  fi
} >> "$GITHUB_STEP_SUMMARY"

# --- Console log (ASCII table) ---
SEP="+----------------------+--------+--------------------------------------------+"
echo "=== Virtual Path ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC1_LABEL}"  "${HC1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER1_LABEL}" "${VER1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT1_LABEL}" "${PPT1_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS1_DETAIL}"
echo "$SEP"
echo ""
echo "=== ActiveMQ Artemis ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC2_LABEL}"  "${HC2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER2_LABEL}" "${VER2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT2_LABEL}" "${PPT2_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS2_DETAIL}"
echo "$SEP"
echo ""
echo "=== ActiveMQ Classic ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"   "${HC3_LABEL}"  "${HC3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"       "${VER3_LABEL}" "${VER3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"     "${PPT3_LABEL}" "${PPT3_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors" ""  "${DS3_DETAIL}"
echo "$SEP"
echo ""
echo "=== Redis unix.sock (redis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"     "${HC4_LABEL}"   "${HC4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"         "${VER4_LABEL}"  "${VER4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Redis sock ping" "${SOCK4_LABEL}" "${SOCK4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Port 6379"       "${PORT4_LABEL}" "${PORT4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"       "${PPT4_LABEL}"  "${PPT4_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"   ""   "${DS4_DETAIL}"
echo "$SEP"
echo ""
echo "=== Redis unix.sock (ioredis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"     "${HC5_LABEL}"   "${HC5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"         "${VER5_LABEL}"  "${VER5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Redis sock ping" "${SOCK5_LABEL}" "${SOCK5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Port 6379"       "${PORT5_LABEL}" "${PORT5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"       "${PPT5_LABEL}"  "${PPT5_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"   ""   "${DS5_DETAIL}"
echo "$SEP"

echo "=== Redis cluster (redis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"        "${HC6_LABEL}"  "${HC6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"            "${VER6_LABEL}" "${VER6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Cluster connection" "${CL6_LABEL}"  "${CL6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Built-in redis"     "${LOC6_LABEL}" "${LOC6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"          "${PPT6_LABEL}" "${PPT6_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"      ""  "${DS6_DETAIL}"
echo "$SEP"
echo ""
echo "=== Redis cluster (ioredis driver) ==="
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Check" "Result" "Details"
echo "$SEP"
printf "| %-20s | %-6s | %-42s |\n" "Healthcheck"        "${HC7_LABEL}"  "${HC7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Version"            "${VER7_LABEL}" "${VER7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Cluster connection" "${CL7_LABEL}"  "${CL7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Built-in redis"     "${LOC7_LABEL}" "${LOC7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "Puppeteer"          "${PPT7_LABEL}" "${PPT7_DETAIL}"
printf "| %-20s | %-6s | %-42s |\n" "DS Log Errors"      ""  "${DS7_DETAIL}"
echo "$SEP"
echo ""

if [ "$FAILED" -eq 1 ]; then
  echo "FINAL_CONCLUSION=failure" >> "$GITHUB_ENV"
  exit 1
else
  echo "FINAL_CONCLUSION=success" >> "$GITHUB_ENV"
fi
