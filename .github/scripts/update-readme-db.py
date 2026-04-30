import json
import re

DBS = [
    ("MySQL",         "mysql"),
    ("PostgreSQL",    "postgres"),
    ("PostgreSQL 14", "postgres14"),
    ("PostgreSQL 15", "postgres15"),
    ("PostgreSQL 16", "postgres16"),
    ("PostgreSQL 17", "postgres17"),
    ("MSSQL",         "mssql"),
    ("Oracle",        "oracle"),
    ("Dameng",        "dameng"),
    ("MariaDB",       "mariadb"),
]


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None


def bool_cell(data, key):
    if data is None:
        return "—"
    val = data.get(key, False)
    return "✅ OK" if val else "❌ FAILED"


def version_cell(data):
    if data is None:
        return "—"
    ok = data.get('version_ok', False)
    actual = data.get('version_actual', '?')
    return f"✅ {actual}" if ok else f"❌ {actual}"


def puppeteer_cell(data):
    if data is None:
        return "—"
    total = data.get('puppeteer_total_failed', 0)
    api = data.get('puppeteer_api_failed', 0)
    wopi = data.get('puppeteer_wopi_failed', 0)
    ok = total <= 5
    return f"{'✅' if ok else '❌'} {total} (API: {api}, WOPI: {wopi})"


def ds_errors_cell(data):
    if data is None:
        return "—"
    n = data.get('ds_log_errors', 0)
    return "✅ 0" if n == 0 else f"❌ {n}"


BADGE = (
    "[![dev-DB-check]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml/badge.svg?branch=main)]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DB-check.yml)"
)

rows = [
    f"| {BADGE} | Healthcheck | Version | Puppeteer | DS Log Errors |",
    "|-------|-------------|---------|-----------|---------------|",
]

for label, key in DBS:
    d = load(f'.github/workflow-results/dev-db-{key}.json')
    rows.append(
        f"| {label} | {bool_cell(d, 'healthy')} | {version_cell(d)}"
        f" | {puppeteer_cell(d)} | {ds_errors_cell(d)} |"
    )

table = "\n".join(rows)

with open('README.md') as f:
    content = f.read()

new_content = re.sub(
    r'(<!-- db-status-start -->).*?(<!-- db-status-end -->)',
    f'\\1\n{table}\n\\2',
    content,
    flags=re.DOTALL,
)

if new_content != content:
    with open('README.md', 'w') as f:
        f.write(new_content)
    print("README updated")
else:
    print("No changes to README")
