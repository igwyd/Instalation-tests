#!/usr/bin/env python3
"""Generate GitHub Pages index.html from workflow result JSON files."""

import json
import os
from datetime import datetime, timezone
from html import escape

REPO = "https://github.com/igwyd/Instalation-tests"
WORKFLOW_BASE = f"{REPO}/actions/workflows"
RESULTS_DIR = ".github/workflow-results"
OUTPUT_DIR = "_site"

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

CSS = """
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 14px; color: #24292f; background: #f6f8fa; }
header { background: #0969da; color: white; padding: 20px 32px; }
header h1 { font-size: 20px; font-weight: 600; }
header p { margin-top: 6px; font-size: 13px; opacity: 0.85; }
header a { color: #cae8ff; text-decoration: none; }
header a:hover { text-decoration: underline; }
main { max-width: 1100px; margin: 24px auto; padding: 0 16px; }
section { background: white; border: 1px solid #d0d7de; border-radius: 6px; margin-bottom: 24px; overflow: hidden; }
.section-header { padding: 12px 16px; border-bottom: 1px solid #d0d7de; display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
.section-header h2 { font-size: 16px; font-weight: 600; }
.section-body { padding: 16px; }
h3 { font-size: 13px; font-weight: 600; margin: 16px 0 6px; color: #57606a; text-transform: uppercase; letter-spacing: 0.04em; }
h3:first-child { margin-top: 0; }
.date { font-weight: normal; text-transform: none; letter-spacing: 0; }
table { width: 100%; border-collapse: collapse; font-size: 13px; margin-bottom: 4px; }
th { background: #f6f8fa; text-align: left; padding: 6px 12px; font-weight: 600; border-bottom: 1px solid #d0d7de; white-space: nowrap; }
td { padding: 6px 12px; border-bottom: 1px solid #eaecef; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f6f8fa; }
td.ok { color: #1a7f37; }
td.fail { color: #cf222e; }
td.na { color: #8c959f; }
footer { text-align: center; padding: 20px 16px; color: #8c959f; font-size: 12px; }
footer a { color: #8c959f; }
"""


def load(filename):
    path = os.path.join(RESULTS_DIR, filename)
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None


def status(ok):
    return "ok" if ok else "fail"


def td_bool(v):
    return f'<td class="{status(v)}">{"✅ OK" if v else "❌ FAILED"}</td>'


def td_version(data):
    if data is None:
        return '<td class="na">—</td>'
    v_ok = data.get("version_ok", False)
    actual = data.get("version_actual", "?") or "?"
    if actual in ("not set", "not-found"):
        actual = "?"
    icon = "✅" if v_ok else "❌"
    return f'<td class="{status(v_ok)}">{icon} {escape(actual)}</td>'


def td_ppt_simple(failed, threshold=5):
    is_ok = failed <= threshold
    icon = "✅" if is_ok else "❌"
    label = "OK" if is_ok else "FAILED"
    return f'<td class="{status(is_ok)}">{icon} {label} ({failed})</td>'


def td_ppt_breakdown(data, threshold=5):
    if data is None:
        return '<td class="na">—</td>'
    total = data.get("puppeteer_total_failed", 0)
    api   = data.get("puppeteer_api_failed", 0)
    wopi  = data.get("puppeteer_wopi_failed", 0)
    is_ok = total <= threshold
    icon  = "✅" if is_ok else "❌"
    return f'<td class="{status(is_ok)}">{icon} {total} (API: {api}, WOPI: {wopi})</td>'


def td_ds_errors(data):
    if data is None:
        return '<td class="na">—</td>'
    n = data.get("ds_log_errors", 0)
    return f'<td class="{status(n == 0)}">{"✅" if n == 0 else "❌"} {n}</td>'


def pkg_table(data, arch_label):
    run_date = (data or {}).get("run_date", "")
    date_part = f' <span class="date">· {escape(run_date)}</span>' if run_date else ""

    rows = []
    if data is None:
        for label in ["EE", "DE", "CE"]:
            rows.append(f'<tr><td>{label}</td>'
                        + '<td class="na">—</td>' * 5 + '</tr>')
        rows.append('<tr><td>EE Release</td>' + '<td class="na">—</td>' * 5 + '</tr>')
        rows.append('<tr><td>EE Upgrade</td>' + '<td class="na">—</td>' * 5 + '</tr>')
    else:
        for key, label in [("ee", "EE"), ("de", "DE"), ("ce", "CE")]:
            ed = data.get(key, {})
            svc_ok = ed.get("services_ok", False)
            svc_cell = (f'<td class="{status(svc_ok)}">'
                        f'SVC: {"✅ OK" if svc_ok else "❌ FAILED"}</td>')
            rows.append(
                f'<tr><td>{label}</td>'
                + td_bool(ed.get("healthy", False))
                + td_version(ed)
                + svc_cell
                + td_ppt_simple(ed.get("puppeteer_failed", 0))
                + td_ds_errors(ed)
                + '</tr>'
            )

        ug = data.get("ee_upgrade", {})

        ver_rel = ug.get("version_release_actual", "?") or "?"
        if ver_rel in ("not set", "not-found"):
            ver_rel = "?"
        jwt_rel = ug.get("jwt_ee_release_exists", False)
        hc_rel  = ug.get("healthy_release", False)
        rows.append(
            f'<tr><td>EE Release</td>'
            + td_bool(hc_rel)
            + f'<td>{escape(ver_rel)}</td>'
            + f'<td class="{status(jwt_rel)}">JWT: {"✅ YES" if jwt_rel else "❌ FAIL"}</td>'
            + '<td class="na">—</td>'
            + '<td class="na">—</td>'
            + '</tr>'
        )

        hc_upg   = ug.get("healthy_upgrade", False)
        jwt_match = ug.get("jwt_match", False)
        rows.append(
            f'<tr><td>EE Upgrade</td>'
            + td_bool(hc_upg)
            + td_version(ug)
            + f'<td class="{status(jwt_match)}">JWT: {"✅ MATCH" if jwt_match else "❌ FAIL"}</td>'
            + td_ppt_simple(ug.get("puppeteer_failed", 0))
            + td_ds_errors(ug)
            + '</tr>'
        )

    thead = ('<thead><tr>'
             '<th>Edition</th><th>Healthcheck</th><th>Version</th>'
             '<th>SVC/JWT</th><th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
             '</tr></thead>')
    return (f'<h3>{arch_label}{date_part}</h3>\n'
            f'<table>{thead}<tbody>' + '\n'.join(rows) + '</tbody></table>\n')


def badge_link(workflow_file, label):
    url = f"{WORKFLOW_BASE}/{workflow_file}"
    return (f'<a href="{url}">'
            f'<img src="{url}/badge.svg?branch=main" alt="{escape(label)}"></a>')


def section(title, workflow_file, badge_label, body_html):
    return (f'<section>\n'
            f'<div class="section-header">'
            f'<h2>{escape(title)}</h2>'
            f'{badge_link(workflow_file, badge_label)}'
            f'</div>\n'
            f'<div class="section-body">\n{body_html}</div>\n'
            f'</section>\n')


def generate():
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    deb_x64   = load("dev-deb-x64.json")
    deb_arm64  = load("dev-deb-arm64.json")
    rpm_x64   = load("dev-rpm-x64.json")
    rpm_arm64  = load("dev-rpm-arm64.json")
    db_data   = {key: load(f"dev-db-{key}.json") for _, key in DBS}
    amq_artemis = load("dev-activemq-artemis.json")
    amq_classic = load("dev-activemq-classic.json")

    # DEB section body
    deb_body = pkg_table(deb_x64, "x64") + pkg_table(deb_arm64, "arm64")

    # RPM section body
    rpm_body = pkg_table(rpm_x64, "x64") + pkg_table(rpm_arm64, "arm64")

    # DB section body
    db_rows = []
    for label, key in DBS:
        d = db_data[key]
        if d is None:
            db_rows.append(f'<tr><td>{escape(label)}</td>'
                           + '<td class="na">—</td>' * 4 + '</tr>')
        else:
            db_rows.append(
                f'<tr><td>{escape(label)}</td>'
                + td_bool(d.get("healthy", False))
                + td_version(d)
                + td_ppt_breakdown(d)
                + td_ds_errors(d)
                + '</tr>'
            )
    db_body = ('<table><thead><tr>'
               '<th>Database</th><th>Healthcheck</th><th>Version</th>'
               '<th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
               '</tr></thead><tbody>'
               + '\n'.join(db_rows)
               + '</tbody></table>\n')

    # ActiveMQ section body
    amq_rows = []
    for label, d in [("Artemis", amq_artemis), ("Classic", amq_classic)]:
        if d is None:
            amq_rows.append(f'<tr><td>{label}</td>'
                            + '<td class="na">—</td>' * 4 + '</tr>')
        else:
            amq_rows.append(
                f'<tr><td>{label}</td>'
                + td_bool(d.get("healthy", False))
                + td_version(d)
                + td_ppt_breakdown(d)
                + td_ds_errors(d)
                + '</tr>'
            )
    amq_body = ('<table><thead><tr>'
                '<th>Type</th><th>Healthcheck</th><th>Version</th>'
                '<th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
                '</tr></thead><tbody>'
                + '\n'.join(amq_rows)
                + '</tbody></table>\n')

    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ONLYOFFICE Docs — Test Results</title>
<style>{CSS}</style>
</head>
<body>
<header>
  <h1>ONLYOFFICE Docs — Installation Test Results</h1>
  <p>Generated: <time>{now}</time> &nbsp;·&nbsp; <a href="{REPO}">GitHub Repository</a></p>
</header>
<main>
{section("DEB Packages (Ubuntu 24.04)", "dev-DEB-x64-arm64.yml", "dev-DEB-x64-arm64", deb_body)}
{section("RPM Packages (CentOS 9)", "dev-RPM-x64-arm64.yml", "dev-RPM-x64-arm64", rpm_body)}
{section("Database Tests", "dev-DB-check.yml", "dev-DB-check", db_body)}
{section("ActiveMQ Tests", "dev-ActiveMQ.yml", "dev-ActiveMQ", amq_body)}
</main>
<footer>Generated automatically · <a href="{REPO}/actions">GitHub Actions</a></footer>
</body>
</html>
"""

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    out_path = os.path.join(OUTPUT_DIR, "index.html")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Generated: {out_path}")


if __name__ == "__main__":
    generate()
