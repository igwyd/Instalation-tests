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

OS_ENTRIES = [
    ("Ubuntu 26.04", "ubuntu2604"),
    ("Debian 12",    "debian12"),
    ("Debian 13",    "debian13"),
    ("CentOS 10",    "centos10"),
    ("RHEL 8",       "rhel8"),
    ("RHEL 9",       "rhel9"),
    ("RHEL 10",      "rhel10"),
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
    total = data.get("puppeteer_total_failed", data.get("puppeteer_failed", 0))
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
                + td_ppt_breakdown(ed)
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
            + td_ppt_breakdown(ug)
            + td_ds_errors(ug)
            + '</tr>'
        )

    thead = ('<thead><tr>'
             '<th>Edition</th><th>Healthcheck</th><th>Version</th>'
             '<th>SVC/JWT</th><th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
             '</tr></thead>')
    return (f'<h3>{arch_label}{date_part}</h3>\n'
            f'<table>{thead}<tbody>' + '\n'.join(rows) + '</tbody></table>\n')


def docker_table(data, arch_label):
    run_date = (data or {}).get("run_date", "")
    date_part = f' <span class="date">· {escape(run_date)}</span>' if run_date else ""

    rows = []
    if data is None:
        for label in ["EE", "DE", "CE"]:
            rows.append(f'<tr><td>{label}</td>'
                        + '<td class="na">—</td>' * 5 + '</tr>')
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
                + td_ppt_breakdown(ed)
                + td_ds_errors(ed)
                + '</tr>'
            )

    thead = ('<thead><tr>'
             '<th>Edition</th><th>Healthcheck</th><th>Version</th>'
             '<th>SVC</th><th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
             '</tr></thead>')
    return (f'<h3>{arch_label}{date_part}</h3>\n'
            f'<table>{thead}<tbody>' + '\n'.join(rows) + '</tbody></table>\n')


def td_svc(data):
    if data is None:
        return '<td class="na">—</td>'
    v = data.get("services_ok", False)
    return f'<td class="{status(v)}">SVC: {"✅ OK" if v else "❌ FAILED"}</td>'


def badge_link(workflow_file, label):
    url = f"{WORKFLOW_BASE}/{workflow_file}"
    return (f'<a href="{url}">'
            f'<img src="{url}/badge.svg?branch=main" alt="{escape(label)}"></a>')


def section(title, workflow_file, badge_label, body_html, run_date=""):
    date_part = (f' <span class="date" style="font-size:12px;color:#8c959f">'
                 f'· {escape(run_date)}</span>') if run_date else ""
    return (f'<section>\n'
            f'<div class="section-header">'
            f'<h2>{escape(title)}</h2>'
            f'{badge_link(workflow_file, badge_label)}'
            f'{date_part}'
            f'</div>\n'
            f'<div class="section-body">\n{body_html}</div>\n'
            f'</section>\n')


def generate():
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    # OS section body
    os_run_date = ""
    os_rows = []
    for os_label, os_key in OS_ENTRIES:
        for arch in ("x64", "arm64"):
            tag = f"dev-{os_key}-{arch}"
            d = load(f"{tag}.json")
            if not os_run_date and d:
                os_run_date = d.get("run_date", "")
            docker = (d or {}).get("docker")
            native = (d or {}).get("native")
            if d is None:
                os_rows.append(
                    f'<tr><td>{escape(os_label)}</td><td>{arch}</td>'
                    + '<td class="na">—</td>' * 8 + '</tr>'
                )
            else:
                d_hc   = (docker or {}).get("healthy", False)
                d_ver  = (docker or {}).get("version_actual", "?") or "?"
                d_vok  = (docker or {}).get("version_ok", False)
                d_ppt  = (docker or {}).get("puppeteer_failed", 0)
                d_api  = (docker or {}).get("puppeteer_api_failed", 0)
                d_wopi = (docker or {}).get("puppeteer_wopi_failed", 0)
                d_pok  = d_ppt <= 5
                n_hc   = (native or {}).get("healthy", False)
                n_ver  = (native or {}).get("version_actual", "?") or "?"
                n_vok  = (native or {}).get("version_ok", False)
                n_ppt  = (native or {}).get("puppeteer_failed", 0)
                n_api  = (native or {}).get("puppeteer_api_failed", 0)
                n_wopi = (native or {}).get("puppeteer_wopi_failed", 0)
                n_pok  = n_ppt <= 5
                d_err  = (docker or {}).get("ds_log_errors", 0)
                n_err  = (native or {}).get("ds_log_errors", 0)
                err_ok = (d_err + n_err) == 0
                os_rows.append(
                    f'<tr>'
                    f'<td>{escape(os_label)}</td>'
                    f'<td>{arch}</td>'
                    + f'<td class="{status(d_hc)}">{"✅ OK" if d_hc else "❌ FAILED"}</td>'
                    + f'<td class="{status(d_vok)}">{"✅" if d_vok else "❌"} {escape(d_ver)}</td>'
                    + f'<td class="{status(n_hc)}">{"✅ OK" if n_hc else "❌ FAILED"}</td>'
                    + f'<td class="{status(n_vok)}">{"✅" if n_vok else "❌"} {escape(n_ver)}</td>'
                    + f'<td class="{status(d_pok)}">{"✅" if d_pok else "❌"} {d_ppt} (API: {d_api}, WOPI: {d_wopi})</td>'
                    + f'<td class="{status(n_pok)}">{"✅" if n_pok else "❌"} {n_ppt} (API: {n_api}, WOPI: {n_wopi})</td>'
                    + f'<td class="{status(err_ok)}">{"✅" if err_ok else "❌"} {d_err + n_err}</td>'
                    + '</tr>'
                )
    os_body = (
        '<table><thead><tr>'
        '<th>OS</th><th>Arch</th>'
        '<th>Docker HC</th><th>Docker Ver</th>'
        '<th>Native HC</th><th>Native Ver</th>'
        '<th>Docker Puppeteer (≤5)</th><th>Native Puppeteer (≤5)</th><th>DS Errors</th>'
        '</tr></thead><tbody>'
        + '\n'.join(os_rows)
        + '</tbody></table>\n'
    )

    deb_x64   = load("dev-deb-x64.json")
    deb_arm64  = load("dev-deb-arm64.json")
    rpm_x64   = load("dev-rpm-x64.json")
    rpm_arm64  = load("dev-rpm-arm64.json")
    docker_deb_x64   = load("dev-docker-deb-x64.json")
    docker_deb_arm64 = load("dev-docker-deb-arm64.json")
    docker_rpm_x64   = load("dev-docker-rpm-x64.json")
    docker_rpm_arm64 = load("dev-docker-rpm-arm64.json")
    db_data   = {key: load(f"dev-db-{key}.json") for _, key in DBS}
    amq_artemis = load("dev-activemq-artemis.json")
    amq_classic = load("dev-activemq-classic.json")
    redis_redis   = load("dev-redis-sock-redis.json")
    redis_ioredis = load("dev-redis-sock-ioredis.json")
    server_checks = load("dev-server-checks.json")

    # DEB section body
    deb_body = pkg_table(deb_x64, "x64") + pkg_table(deb_arm64, "arm64")

    # RPM section body
    rpm_body = pkg_table(rpm_x64, "x64") + pkg_table(rpm_arm64, "arm64")

    # Docker DEB section body
    docker_deb_body = docker_table(docker_deb_x64, "x64") + docker_table(docker_deb_arm64, "arm64")

    # Docker RPM section body
    docker_rpm_body = docker_table(docker_rpm_x64, "x64") + docker_table(docker_rpm_arm64, "arm64")

    # DB section body
    db_run_date = next((db_data[k].get("run_date", "") for _, k in DBS if db_data.get(k)), "")
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

    # Redis section body
    def redis_driver_table(label, d):
        run_date = (d or {}).get("run_date", "")
        date_part = f' <span class="date">· {escape(run_date)}</span>' if run_date else ""
        thead = ('<thead><tr>'
                 '<th>Healthcheck</th><th>Version</th>'
                 '<th>Redis sock ping</th><th>Port 6379 closed</th>'
                 '<th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
                 '</tr></thead>')
        if d is None:
            row = '<tr>' + '<td class="na">—</td>' * 6 + '</tr>'
        else:
            hc      = d.get("healthy", False)
            ver_ok  = d.get("version_ok", False)
            ver_act = d.get("version_actual", "?") or "?"
            sock    = d.get("redis_sock_ok", False)
            port    = d.get("port_6379_closed", False)
            ppt     = d.get("puppeteer_total_failed", 0)
            ppt_api = d.get("puppeteer_api_failed", 0)
            ppt_wopi= d.get("puppeteer_wopi_failed", 0)
            ppt_ok  = ppt <= 5
            ds_err  = d.get("ds_log_errors", 0)
            row = (
                '<tr>'
                + f'<td class="{status(hc)}">{"✅ OK" if hc else "❌ FAILED"}</td>'
                + f'<td class="{status(ver_ok)}">{"✅" if ver_ok else "❌"} {escape(ver_act)}</td>'
                + f'<td class="{status(sock)}">{"✅ OK" if sock else "❌ FAILED"}</td>'
                + f'<td class="{status(port)}">{"✅ OK" if port else "❌ FAILED"}</td>'
                + f'<td class="{status(ppt_ok)}">{"✅" if ppt_ok else "❌"} {ppt} (API: {ppt_api}, WOPI: {ppt_wopi})</td>'
                + f'<td class="{status(ds_err == 0)}">{"✅" if ds_err == 0 else "❌"} {ds_err}</td>'
                + '</tr>'
            )
        return (f'<h3>{escape(label)}{date_part}</h3>\n'
                f'<table>{thead}<tbody>{row}</tbody></table>\n')

    redis_body = (redis_driver_table("redis", redis_redis)
                  + redis_driver_table("ioredis", redis_ioredis))

    # SERVER checks section body
    run_date = (server_checks or {}).get("run_date", "")
    date_part = f' <span class="date">· {escape(run_date)}</span>' if run_date else ""
    server_rows = []
    for label, key in [("S3 useDirectStorageUrls=false", "s3_false"), ("S3 useDirectStorageUrls=true", "s3_true")]:
        d = (server_checks or {}).get(key)
        if d is None:
            server_rows.append(f'<tr><td>{label}</td>'
                               + '<td class="na">—</td>' * 4 + '</tr>')
        else:
            hc     = d.get("healthy", False)
            ver_ok = d.get("version_ok", False)
            ver    = d.get("version_actual", "?") or "?"
            ds_err = d.get("ds_log_errors", 0)
            server_rows.append(
                f'<tr>'
                f'<td>{label}</td>'
                + f'<td class="{status(hc)}">{"✅ OK" if hc else "❌ FAILED"}</td>'
                + f'<td class="{status(ver_ok)}">{"✅" if ver_ok else "❌"} {escape(ver)}</td>'
                + td_ppt_breakdown(d)
                + f'<td class="{status(ds_err == 0)}">{"✅" if ds_err == 0 else "❌"} {ds_err}</td>'
                + '</tr>'
            )
    server_body = (
        f'<h3>EE{date_part}</h3>\n'
        '<table><thead><tr>'
        '<th>Cycle</th><th>Healthcheck</th><th>Version</th>'
        '<th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
        '</tr></thead><tbody>'
        + '\n'.join(server_rows)
        + '</tbody></table>\n'
    )

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
{section("Docker DEB (Ubuntu 24.04)", "dev-Docker-DEB-x64-arm64.yml", "dev-Docker-DEB-x64-arm64", docker_deb_body)}
{section("Docker RPM (CentOS 9)", "dev-Docker-RPM-x64-arm64.yml", "dev-Docker-RPM-x64-arm64", docker_rpm_body)}
{section("OS Tests (OneClickInstall)", "dev-OS-x64-arm64.yml", "dev-OS-x64-arm64", os_body, os_run_date)}
{section("Database Tests", "dev-DB-check.yml", "dev-DB-check", db_body, db_run_date)}
{section("ActiveMQ Tests", "dev-ActiveMQ.yml", "dev-ActiveMQ", amq_body)}
{section("Redis unix.sock Tests", "dev-Redis-unix.sock.yml", "dev-Redis-unix.sock x64", redis_body)}
{section("SERVER Checks (AWS S3)", "dev-SERVER-checks.yml", "dev SERVER checks", server_body)}
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
