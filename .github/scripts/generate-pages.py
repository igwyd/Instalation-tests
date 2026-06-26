#!/usr/bin/env python3
"""Generate multi-page dashboard from workflow result JSON files."""

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
nav.breadcrumb { background: #0550ae; padding: 8px 32px; font-size: 13px; }
nav.breadcrumb a { color: #cae8ff; text-decoration: none; }
nav.breadcrumb a:hover { text-decoration: underline; }
nav.breadcrumb span { color: #cae8ff; opacity: 0.6; margin: 0 6px; }
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
.cards { display: flex; gap: 20px; flex-wrap: wrap; margin: 32px 0; }
.card { flex: 1; min-width: 260px; background: white; border: 1px solid #d0d7de; border-radius: 8px; padding: 28px 24px; text-decoration: none; color: inherit; display: flex; flex-direction: column; transition: border-color 0.15s, box-shadow 0.15s; }
.card:hover { box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
.card-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 10px; }
.card-title { font-size: 32px; font-weight: 700; margin-bottom: 12px; }
.card-desc { color: #57606a; font-size: 13px; line-height: 1.6; }
.card-arrow { margin-top: auto; padding-top: 20px; font-size: 13px; font-weight: 600; }
.card-dev .card-label, .card-dev .card-arrow { color: #0969da; }
.card-dev:hover { border-color: #0969da; }
.card-release .card-label, .card-release .card-arrow { color: #1a7f37; }
.card-release:hover { border-color: #1a7f37; }
.card-common .card-label, .card-common .card-arrow { color: #9a6700; }
.card-common:hover { border-color: #9a6700; }
.placeholder { text-align: center; padding: 64px 16px; color: #8c959f; }
.placeholder p { font-size: 15px; }
footer { text-align: center; padding: 20px 16px; color: #8c959f; font-size: 12px; }
footer a { color: #8c959f; }
.header-inner { display: flex; align-items: flex-start; gap: 16px; }
.snap-picker select { font-size: 11px; padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(255,255,255,0.35); background: rgba(0,0,0,0.25); color: white; cursor: pointer; margin-top: 3px; max-width: 230px; }
.snap-picker select option { background: #24292f; color: white; }
.k6-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 4px; }
.k6-chart-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #57606a; margin-bottom: 6px; }
.k6-bar-row { display: flex; align-items: center; gap: 6px; margin: 3px 0; font-size: 11px; }
.k6-bar-label { width: 82px; text-align: right; flex-shrink: 0; color: #57606a; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.k6-bar-track { flex: 1; background: #eaecef; border-radius: 2px; height: 13px; overflow: hidden; min-width: 40px; }
.k6-bar-fill { height: 100%; border-radius: 2px; }
.k6-bar-val { width: 52px; text-align: right; flex-shrink: 0; color: #24292f; font-weight: 500; }
.k6-bar-p90 { width: 76px; text-align: right; flex-shrink: 0; color: #8c959f; }
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
    is_ok = total <= threshold
    icon  = "✅" if is_ok else "❌"
    return f'<td class="{status(is_ok)}">{icon} {total}</td>'


def td_ds_errors(data):
    if data is None:
        return '<td class="na">—</td>'
    n = data.get("ds_log_errors", 0)
    return f'<td>{n}</td>'


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


SNAPSHOT_JS = """<script>
(function(){
  var sel = document.getElementById('snap-sel');
  if (!sel) return;
  var path = window.location.pathname;
  fetch('/snapshots/manifest.json')
    .then(function(r){ return r.json(); })
    .then(function(d){
      (d.snapshots || []).forEach(function(s){
        var o = document.createElement('option');
        o.value = s.url;
        o.textContent = s.label;
        if (path.indexOf(s.id) !== -1) o.selected = true;
        sel.appendChild(o);
      });
      if (path.indexOf('/snapshots/') === -1) sel.value = '/';
    })
    .catch(function(){});
})();
</script>"""


def page_html(title, body, nav_html=""):
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{escape(title)}</title>
<style>{CSS}</style>
</head>
<body>
<header>
  <div class="header-inner">
    <div class="snap-picker">
      <select id="snap-sel" onchange="if(this.value) window.location.href=this.value">
        <option value="/">⬤ Latest</option>
      </select>
    </div>
    <div>
      <h1>ONLYOFFICE Docs — Test Results</h1>
      <p>Generated: <time>{now}</time> &nbsp;·&nbsp; <a href="{REPO}">GitHub Repository</a></p>
    </div>
  </div>
</header>
{nav_html}<main>
{body}</main>
<footer>Generated automatically · <a href="{REPO}/actions">GitHub Actions</a></footer>
{SNAPSHOT_JS}
</body>
</html>
"""


def breadcrumb(page_title):
    return (f'<nav class="breadcrumb">'
            f'<a href="index.html">← Main</a>'
            f'<span>/</span>'
            f'{escape(page_title)}'
            f'</nav>\n')


def write(filename, html):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    out_path = os.path.join(OUTPUT_DIR, filename)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Generated: {out_path}")


def k6_section(db_data):
    TRENDS = [
        ("auth",        "Auth",        "#0969da"),
        ("connect",     "Connect",     "#2da44e"),
        ("convert",     "Convert",     "#bf8700"),
        ("isSaveLock",  "isSaveLock",  "#8250df"),
        ("open",        "Open",        "#cf222e"),
        ("saveChanges", "SaveChanges", "#0a3069"),
    ]
    EXCEPTION_KEYS = ["auth", "connect", "convert", "isSaveLock", "open", "saveChanges"]

    # --- Exceptions table ---
    exc_rows = []
    for label, key in DBS:
        d = db_data.get(key)
        k6 = (d or {}).get("k6")
        if k6 is None:
            exc_rows.append(
                f'<tr><td>{escape(label)}</td>'
                + '<td class="na" colspan="8">—</td></tr>'
            )
            continue
        exc = k6.get("exceptions", {})
        total = exc.get("all", 0)
        exc_ok = total == 0
        row = (f'<tr><td>{escape(label)}</td>'
               + f'<td class="{status(exc_ok)}">{"✅" if exc_ok else "❌"} {total}</td>')
        for ek in EXCEPTION_KEYS:
            row += f'<td>{exc.get(ek, 0)}</td>'
        row += f'<td>{exc.get("manual_close", "—")}</td></tr>'
        exc_rows.append(row)

    exc_html = (
        '<table><thead><tr>'
        '<th>DB</th><th>All Exceptions</th>'
        '<th>Auth</th><th>Connect</th><th>Convert</th>'
        '<th>isSaveLock</th><th>Open</th><th>SaveChanges</th>'
        '<th>Manual Close</th>'
        '</tr></thead><tbody>'
        + '\n'.join(exc_rows)
        + '</tbody></table>\n'
    )

    # --- Bar charts (one per trend metric) ---
    charts_html = '<div class="k6-grid">\n'
    for trend_key, trend_label, color in TRENDS:
        vals = []
        for db_label, db_key in DBS:
            d = db_data.get(db_key)
            k6 = (d or {}).get("k6") or {}
            t = k6.get("trends", {}).get(trend_key, {})
            avg = t.get("avg") if t else None
            p90 = t.get("p90") if t else None
            vals.append((db_label, avg, p90))

        max_val = max((v[1] for v in vals if v[1] is not None and v[1] > 0), default=1) or 1

        chart = f'<div>\n<div class="k6-chart-title">{escape(trend_label)} avg (ms)</div>\n'
        for db_label, avg, p90 in vals:
            chart += '<div class="k6-bar-row">'
            chart += f'<span class="k6-bar-label">{escape(db_label)}</span>'
            if avg is None:
                chart += '<div class="k6-bar-track"></div>'
                chart += '<span class="k6-bar-val">—</span>'
                chart += '<span class="k6-bar-p90"></span>'
            else:
                pct = min(avg / max_val * 100, 100)
                chart += (f'<div class="k6-bar-track">'
                          f'<div class="k6-bar-fill" style="width:{pct:.1f}%;background-color:{color}"></div>'
                          f'</div>')
                chart += f'<span class="k6-bar-val">{avg:.2f}ms</span>'
                p90_str = f'p90: {p90:.2f}ms' if p90 is not None else ''
                chart += f'<span class="k6-bar-p90">{p90_str}</span>'
            chart += '</div>\n'
        chart += '</div>\n'
        charts_html += chart
    charts_html += '</div>\n'

    return (
        '<h3>k6 Load Test — Exceptions</h3>\n'
        + exc_html
        + '<h3>k6 Load Test — Response Times</h3>\n'
        + charts_html
    )


def generate_main():
    cards_html = (
        '<div class="cards">\n'
        '<a class="card card-dev" href="dev.html">\n'
        '  <div class="card-label">Pre-release builds</div>\n'
        '  <div class="card-title">DEV</div>\n'
        '  <div class="card-desc">DEB, RPM, Docker, OS (OneClickInstall),<br>Database, ActiveMQ, Redis, SERVER checks</div>\n'
        '  <div class="card-arrow">Open →</div>\n'
        '</a>\n'
        '<a class="card card-release" href="release.html">\n'
        '  <div class="card-label">Official releases</div>\n'
        '  <div class="card-title">RELEASE</div>\n'
        '  <div class="card-desc">DEB, RPM, Docker DEB, Docker RPM, K8s EKS arm64</div>\n'
        '  <div class="card-arrow">Open →</div>\n'
        '</a>\n'
        '<a class="card card-common" href="common.html">\n'
        '  <div class="card-label">Other tests</div>\n'
        '  <div class="card-title">COMMON</div>\n'
        '  <div class="card-desc">Compile from source, OneClickInstall,<br>k6 load tests, Puppeteer smoke tests</div>\n'
        '  <div class="card-arrow">Open →</div>\n'
        '</a>\n'
        '</div>\n'
    )
    write("index.html", page_html("ONLYOFFICE Docs — Test Results", cards_html))


def generate_dev():
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
                    + '<td class="na">—</td>' * 7 + '</tr>'
                )
            else:
                d_hc   = (docker or {}).get("healthy", False)
                d_ver  = (docker or {}).get("version_actual", "?") or "?"
                d_vok  = (docker or {}).get("version_ok", False)
                d_ppt  = (docker or {}).get("puppeteer_failed", 0)
                d_pok  = d_ppt <= 5
                n_hc   = (native or {}).get("healthy", False)
                n_ver  = (native or {}).get("version_actual", "?") or "?"
                n_vok  = (native or {}).get("version_ok", False)
                n_ppt  = (native or {}).get("puppeteer_failed", 0)
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
                    + f'<td class="{status(d_pok)}">{"✅" if d_pok else "❌"} {d_ppt}</td>'
                    + f'<td class="{status(n_pok)}">{"✅" if n_pok else "❌"} {n_ppt}</td>'
                    + f'<td class="{status(err_ok)}">{"✅" if err_ok else "❌"} {d_err + n_err}</td>'
                    + '</tr>'
                )
    os_body = (
        '<table><thead><tr>'
        '<th>OS</th><th>Arch</th>'
        '<th>Docker HC</th><th>Docker Ver</th>'
        '<th>Native HC</th><th>Native Ver</th>'
        '<th>Docker Puppeteer (≤5)</th><th>Native Puppeteer (≤5)</th><th>DS Log Errors</th>'
        '</tr></thead><tbody>'
        + '\n'.join(os_rows)
        + '</tbody></table>\n'
    )

    deb_x64        = load("dev-deb-x64.json")
    deb_arm64      = load("dev-deb-arm64.json")
    rpm_x64        = load("dev-rpm-x64.json")
    rpm_arm64      = load("dev-rpm-arm64.json")
    docker_deb_x64   = load("dev-docker-deb-x64.json")
    docker_deb_arm64 = load("dev-docker-deb-arm64.json")
    docker_rpm_x64   = load("dev-docker-rpm-x64.json")
    docker_rpm_arm64 = load("dev-docker-rpm-arm64.json")
    db_data        = {key: load(f"dev-db-{key}.json") for _, key in DBS}
    server_checks  = load("dev-server-checks.json")

    deb_body        = pkg_table(deb_x64, "x64") + pkg_table(deb_arm64, "arm64")
    rpm_body        = pkg_table(rpm_x64, "x64") + pkg_table(rpm_arm64, "arm64")
    docker_deb_body = docker_table(docker_deb_x64, "x64") + docker_table(docker_deb_arm64, "arm64")
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
               + '</tbody></table>\n'
               + k6_section(db_data))

    # SERVER checks section body
    server_run_date = (server_checks or {}).get("run_date", "")
    server_date_part = f' <span class="date">· {escape(server_run_date)}</span>' if server_run_date else ""
    server_rows = []
    for label, key in [("S3 useDirectStorageUrls=false", "s3_false"), ("S3 useDirectStorageUrls=true", "s3_true"), ("S3 s3ForcePathStyle=true", "s3_path_style"), ("S3 AWS KMS", "s3_kms"), ("Azure Blob Storage useDirectStorageUrls=false", "az_false"), ("Virtual Path", "vpath"), ("ActiveMQ Artemis", "amqp_artemis"), ("ActiveMQ Classic", "amqp_classic")]:
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
    redis_server_rows = []
    for label, key in [("redis", "redis_redis"), ("ioredis", "redis_ioredis")]:
        d = (server_checks or {}).get(key)
        if d is None:
            redis_server_rows.append(f'<tr><td>{label}</td>' + '<td class="na">—</td>' * 6 + '</tr>')
        else:
            hc     = d.get("healthy", False)
            ver_ok = d.get("version_ok", False)
            ver    = d.get("version_actual", "?") or "?"
            sock   = d.get("redis_sock_ok", False)
            port   = d.get("port_6379_closed", False)
            ds_err = d.get("ds_log_errors", 0)
            redis_server_rows.append(
                f'<tr>'
                f'<td>{label}</td>'
                + f'<td class="{status(hc)}">{"✅ OK" if hc else "❌ FAILED"}</td>'
                + f'<td class="{status(ver_ok)}">{"✅" if ver_ok else "❌"} {escape(ver)}</td>'
                + f'<td class="{status(sock)}">{"✅ OK" if sock else "❌ FAILED"}</td>'
                + f'<td class="{status(port)}">{"✅ OK" if port else "❌ FAILED"}</td>'
                + td_ppt_breakdown(d)
                + f'<td class="{status(ds_err == 0)}">{"✅" if ds_err == 0 else "❌"} {ds_err}</td>'
                + '</tr>'
            )

    server_body = (
        f'<h3>EE{server_date_part}</h3>\n'
        '<table><thead><tr>'
        '<th>Cycle</th><th>Healthcheck</th><th>Version</th>'
        '<th>Puppeteer (=0)</th><th>DS Log Errors</th>'
        '</tr></thead><tbody>'
        + '\n'.join(server_rows)
        + '</tbody></table>\n'
        + '<h3>EE — Redis unix.sock</h3>\n'
        '<table><thead><tr>'
        '<th>Driver</th><th>Healthcheck</th><th>Version</th>'
        '<th>Redis sock ping</th><th>Port 6379 closed</th>'
        '<th>Puppeteer (=0)</th><th>DS Log Errors</th>'
        '</tr></thead><tbody>'
        + '\n'.join(redis_server_rows)
        + '</tbody></table>\n'
    )

    body = (
        section("DEB Packages (Ubuntu 24.04)", "dev-DEB-x64-arm64.yml", "dev-DEB-x64-arm64", deb_body)
        + section("RPM Packages (CentOS 9)", "dev-RPM-x64-arm64.yml", "dev-RPM-x64-arm64", rpm_body)
        + section("Docker DEB (Ubuntu 24.04)", "dev-Docker-DEB-x64-arm64.yml", "dev-Docker-DEB-x64-arm64", docker_deb_body)
        + section("Docker RPM (CentOS 9)", "dev-Docker-RPM-x64-arm64.yml", "dev-Docker-RPM-x64-arm64", docker_rpm_body)
        + section("OS Tests (OneClickInstall)", "dev-OS-x64-arm64.yml", "dev-OS-x64-arm64", os_body, os_run_date)
        + section("Database Tests", "dev-DB-check.yml", "dev-DB-check", db_body, db_run_date)
        + section("SERVER Checks (AWS S3)", "dev-SERVER-checks.yml", "dev SERVER checks", server_body)
    )
    write("dev.html", page_html("DEV — ONLYOFFICE Docs Test Results", body, breadcrumb("DEV")))


def generate_release():
    k8s = load("release-k8s-eks-arm64.json")
    run_date = (k8s or {}).get("run_date", "")
    date_part = f' <span class="date">· {escape(run_date)}</span>' if run_date else ""

    ee = (k8s or {}).get("ee", {})
    if k8s is None:
        row = '<tr><td>DE</td>' + '<td class="na">—</td>' * 5 + '</tr>'
    else:
        hc      = ee.get("healthy", False)
        ver_ok  = ee.get("version_ok", False)
        ver_act = ee.get("version_actual", "?") or "?"
        pods_ok = ee.get("pods_ok", False)
        ppt     = ee.get("puppeteer_failed", 0)
        ppt_ok  = ppt <= 5
        ds_err  = ee.get("ds_log_errors", 0)
        row = (
            '<tr><td>DE</td>'
            + f'<td class="{status(hc)}">{"✅ OK" if hc else "❌ FAILED"}</td>'
            + f'<td class="{status(ver_ok)}">{"✅" if ver_ok else "❌"} {escape(ver_act)}</td>'
            + f'<td class="{status(pods_ok)}">{"✅ OK" if pods_ok else "❌ FAILED"}</td>'
            + f'<td class="{status(ppt_ok)}">{"✅" if ppt_ok else "❌"} {ppt}</td>'
            + f'<td class="{status(ds_err == 0)}">{"✅" if ds_err == 0 else "❌"} {ds_err}</td>'
            + '</tr>'
        )

    k8s_body = (
        f'<h3>arm64{date_part}</h3>\n'
        '<table><thead><tr>'
        '<th>Edition</th><th>Healthcheck</th><th>Version</th>'
        '<th>Pods</th><th>Puppeteer (≤5)</th><th>DS Log Errors</th>'
        '</tr></thead><tbody>'
        + row
        + '</tbody></table>\n'
    )

    body = section("K8s EKS arm64", "release-K8s-EKS-arm64.yml", "release-K8s-EKS-arm64", k8s_body)
    write("release.html", page_html("RELEASE — ONLYOFFICE Docs Test Results", body, breadcrumb("RELEASE")))


def generate_common():
    body = '<div class="placeholder"><p>No data yet — coming soon</p></div>\n'
    write("common.html", page_html("COMMON — ONLYOFFICE Docs Test Results", body, breadcrumb("COMMON")))


if __name__ == "__main__":
    generate_main()
    generate_dev()
    generate_release()
    generate_common()
