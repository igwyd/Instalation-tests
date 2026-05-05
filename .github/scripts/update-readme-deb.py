import json
import re


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None


def edition_cell(data, edition):
    if data is None:
        return "—"
    ed = data.get(edition)
    if ed is None:
        return "—"
    return "✅ OK" if ed.get('conclusion') == 'success' else "❌ FAILED"


BADGE = (
    "[![dev-DEB-x64-arm64]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main)]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml)"
)

x64   = load('.github/workflow-results/dev-deb-x64.json')
arm64 = load('.github/workflow-results/dev-deb-arm64.json')

table = "\n".join([
    f"| {BADGE} | EE | DE | CE | EE Upgrade |",
    "|---|---|---|---|---|",
    f"| x64   | {edition_cell(x64,   'ee')} | {edition_cell(x64,   'de')} | {edition_cell(x64,   'ce')} | {edition_cell(x64,   'ee_upgrade')} |",
    f"| arm64 | {edition_cell(arm64, 'ee')} | {edition_cell(arm64, 'de')} | {edition_cell(arm64, 'ce')} | {edition_cell(arm64, 'ee_upgrade')} |",
])

with open('README.md') as f:
    content = f.read()

new_content = re.sub(
    r'(<!-- deb-status-start -->).*?(<!-- deb-status-end -->)',
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
