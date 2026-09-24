"""Smoke test for a fresh ONLYOFFICE Apps (DocSpace) install: complete the first-run wizard,
log in, create a .docx and open it in the editor — then check the editor really comes from the
Docs installed on this server (Apps serves it under /ds-vpath/, the version is reported by Docs).

Password comes from env APPS_ADMIN_PASSWORD (never printed); APPS_LICENSE_KEY (the EE or DE license,
picked by the workflow) is uploaded when the wizard demands a license. Writes SMOKE_OK / SMOKE_INFO and
LICENSE_REQUIRED (whether a fresh wizard asked for a license, i.e. paid Apps) to GITHUB_ENV.
API facts: DocSpace-server/-client release/v4.0.0 (SettingsController, FirstTimeTenantSettings,
AuthenticationController, FilesController, EditorController; client createPasswordHash).
"""
import argparse, hashlib, os, sys
from urllib.parse import urlparse
from playwright.sync_api import sync_playwright

p = argparse.ArgumentParser()
p.add_argument('--url', required=True)            # http://<IP>
p.add_argument('--email', required=True)
p.add_argument('--expected-version', required=True)  # Docs version, e.g. 10.0.0.105
p.add_argument('--out', default='out')
a = p.parse_args()
os.makedirs(a.out, exist_ok=True)
password = os.environ['APPS_ADMIN_PASSWORD']
steps = []


def set_env(**kv):
    env = os.environ.get('GITHUB_ENV')
    if env:
        with open(env, 'a') as f:
            f.writelines(f'{k}={v}\n' for k, v in kv.items())


def done(ok, info):
    print(('OK: ' if ok else 'FAILED: ') + info)
    set_env(SMOKE_OK=str(ok).lower(), SMOKE_INFO=info)
    sys.exit(0 if ok else 1)


def api(req, method, path, **kw):
    r = req.fetch(a.url + path, method=method, **kw)
    if not r.ok:
        done(False, f'{method} {path} -> HTTP {r.status}: {r.text()[:200]}')
    return r.json().get('response')


with sync_playwright() as pw:
    req = pw.request.new_context(extra_http_headers={'Accept': 'application/json'})

    s = api(req, 'GET', '/api/2.0/settings')
    ph = s['passwordHash']
    pw_hash = hashlib.pbkdf2_hmac('sha256', password.encode(), ph['salt'].encode(),
                                  ph['iterations'], ph['size'] // 8).hex()

    token = s.get('wizardToken')
    if token:
        license_required = bool(api(req, 'GET', '/api/2.0/settings/license/required'))
        set_env(LICENSE_REQUIRED=str(license_required).lower())
        print(f'wizard requires a license: {license_required}')
        if license_required:
            lic = os.environ.get('APPS_LICENSE_KEY', '')
            if not lic:
                done(False, 'wizard requires a license and no license secret is set for this edition')
            api(req, 'POST', '/api/2.0/settings/license', headers={'confirm': token},
                multipart={'files': {'name': 'license.lic', 'mimeType': 'application/octet-stream',
                                     'buffer': lic.encode()}})
            steps.append('license uploaded')
        api(req, 'PUT', '/api/2.0/settings/wizard/complete', headers={'confirm': token},
            data={'email': a.email, 'passwordHash': pw_hash, 'lng': 'en', 'timeZone': 'UTC'})
        steps.append('wizard completed')
    else:
        steps.append('wizard already completed')

    auth = api(req, 'POST', '/api/2.0/authentication', data={'userName': a.email, 'passwordHash': pw_hash})
    if not auth.get('token'):
        done(False, f'login returned no token: {auth}')
    hdr = {'Authorization': auth['token']}

    ds = api(req, 'GET', '/api/2.0/files/docservice?version=true', headers=hdr)
    print(f"docservice: public={ds.get('docServiceUrl')} internal={ds.get('docServiceUrlInternal')} "
          f"version={ds.get('version')}")
    if a.expected_version not in str(ds.get('version')):
        done(False, f"Apps talks to Docs {ds.get('version')}, expected {a.expected_version} "
                    f"(internal {ds.get('docServiceUrlInternal')})")
    steps.append(f"Docs {ds.get('version')} via {ds.get('docServiceUrlInternal')}")

    file_id = api(req, 'POST', '/api/2.0/files/@my/file', headers=hdr, data={'title': 'smoke.docx'})['id']
    editor_url = api(req, 'GET', f'/api/2.0/files/file/{file_id}/openedit', headers=hdr)['editorUrl']
    print(f'file {file_id}, editorUrl {editor_url}')

    browser = pw.chromium.launch()
    ctx = browser.new_context(viewport={'width': 1440, 'height': 900})
    ctx.add_cookies([{'name': 'asc_auth_key', 'value': auth['token'], 'url': a.url}])
    # the Docs editor posts {event: 'onDocumentReady'} to the parent once the document is loaded
    ctx.add_init_script("window.__docReady = false; window.addEventListener('message', e => {"
                        " if (String(e.data).includes('onDocumentReady')) window.__docReady = true; });")
    page = ctx.new_page()
    try:
        page.goto(f'{a.url}/doceditor?fileId={file_id}', wait_until='domcontentloaded', timeout=60000)
        frame = page.wait_for_selector('iframe[name="frameEditor"]', timeout=90000)
        src = frame.get_attribute('src') or ''
        page.wait_for_function('window.__docReady === true', timeout=120000)
    except Exception as e:
        page.screenshot(path=f'{a.out}/editor.png')
        done(False, f'editor did not load: {str(e).splitlines()[0]}')
    page.screenshot(path=f'{a.out}/editor.png')
    browser.close()

    # the editor must be served by this server (Apps proxies its Docs under /ds-vpath/), not a CDN/other host
    if urlparse(src).hostname not in (None, urlparse(a.url).hostname):
        done(False, f'editor iframe comes from another host: {src}')
    steps.append(f'editor opened ({urlparse(src).path.split("/web-apps")[0] or "/"})')
    done(True, '; '.join(steps))
