import json
import re


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
    return "✅ 0 errors" if n == 0 else f"❌ {n} errors"


def date_cell(data):
    if data is None:
        return "—"
    return data.get('run_date', '—')


a = load('.github/workflow-results/dev-activemq-artemis.json')
c = load('.github/workflow-results/dev-activemq-classic.json')

BADGE = (
    "[![dev-ActiveMQ]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml/badge.svg?branch=main)]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-ActiveMQ.yml)"
)

table = "\n".join([
    f"| {BADGE} | Artemis | Classic |",
    "|---------------------------------------|---------|---------|",
    f"| Healthcheck   | {bool_cell(a, 'healthy')} | {bool_cell(c, 'healthy')} |",
    f"| Version       | {version_cell(a)}   | {version_cell(c)} |",
    f"| Puppeteer     | {puppeteer_cell(a)} | {puppeteer_cell(c)} |",
    f"| DS Log Errors | {ds_errors_cell(a)} | {ds_errors_cell(c)} |",
    f"| Last run      | {date_cell(a)}      | {date_cell(c)} |",
])

with open('README.md') as f:
    content = f.read()

new_content = re.sub(
    r'(<!-- activemq-status-start -->).*?(<!-- activemq-status-end -->)',
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
