"""Docs /welcome page as a user sees it: open it, press "Install free apps" and read the command from the
pop-up (the page may rewrite it in the browser, so the static HTML is not the truth). Writes WELCOME_* to
GITHUB_ENV; env: EXPECTED_PLATFORM, EXPECTED_ADMIN_PANEL, EXPECTED_APPS_SCRIPT."""
import os, re, sys
from playwright.sync_api import sync_playwright

url, out, insecure = sys.argv[1], sys.argv[2], len(sys.argv) > 3
os.makedirs(out, exist_ok=True)
platform = admin = 'missing'
placeholders, cmd, err = [], 'not found', ''
with sync_playwright() as pw:
    browser = pw.chromium.launch()
    page = browser.new_context(ignore_https_errors=insecure, viewport={'width': 1440, 'height': 900}).new_page()
    try:
        page.goto(f'{url}/welcome/', wait_until='domcontentloaded', timeout=60000)
        html = page.content()
        open(f'{out}/welcome.html', 'w', encoding='utf-8').write(html)
        attr = lambda n: page.evaluate(f"document.documentElement.getAttribute('{n}') || 'missing'")
        platform, admin = attr('data-platform'), attr('data-has-admin-panel')
        placeholders = sorted(set(re.findall(r'\{\{\s*\w+\s*\}\}', html)))
        page.locator('button.install-open-btn').first.click(timeout=30000)
        pre = page.locator('#welcome2-modal-install .install-variant pre:visible').first
        pre.wait_for(timeout=15000)
        cmd = ' '.join(pre.inner_text().split())
    except Exception as e:
        err = str(e).splitlines()[0]
    page.screenshot(path=f'{out}/welcome.png')
    browser.close()

mode = 'docker' if os.environ['EXPECTED_PLATFORM'] == 'docker' else 'package'
script = os.environ['EXPECTED_APPS_SCRIPT']
expected = f'curl -O https://download.onlyoffice.com/apps/{script} && bash {script} {mode}'
ok = platform == os.environ['EXPECTED_PLATFORM'] and not placeholders and cmd == expected
print(f'data-platform={platform} (expected {os.environ["EXPECTED_PLATFORM"]})')
print(f'data-has-admin-panel={admin} (expected {os.environ["EXPECTED_ADMIN_PANEL"]})')
print(f'unsubstituted placeholders: {placeholders or "none"}')
print(f'command in the pop-up: {cmd}\nexpected:              {expected}' + (f'\nerror: {err}' if err else ''))
with open(os.environ['GITHUB_ENV'], 'a') as f:
    f.write(f'WELCOME_OK={str(ok).lower()}\nWELCOME_PLATFORM={platform}\nWELCOME_ADMIN_PANEL={admin}\n')
    f.write(f'WELCOME_ADMIN_PANEL_OK={str(admin == os.environ["EXPECTED_ADMIN_PANEL"]).lower()}\n')
    f.write(f'WELCOME_CMD={cmd}\n')
