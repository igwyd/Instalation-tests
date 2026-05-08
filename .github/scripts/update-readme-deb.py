import json
import re


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None


def hc(ok):
    return "✅ OK" if ok else "❌ FAILED"


def ver(ok, actual):
    icon = "✅" if ok else "❌"
    v = actual if actual and actual not in ("not set", "not-found") else "?"
    return f"{icon} {v}"


def svc(ok):
    return "SVC: ✅ OK" if ok else "SVC: ❌ FAILED"


def jwt_flag(ok, true_label, false_label="FAIL"):
    return f"JWT: ✅ {true_label}" if ok else f"JWT: ❌ {false_label}"


def ppt(failed):
    ok = failed <= 5
    return f"{'✅' if ok else '❌'} {'OK' if ok else 'FAILED'} ({failed})"


def ds_err(count):
    ok = count == 0
    return f"{'✅' if ok else '❌'} {'OK' if ok else 'FAILED'} ({count})"


def arch_table(data):
    if data is None:
        rows = [
            "| EE | — | — | — | — | — |",
            "| DE | — | — | — | — | — |",
            "| CE | — | — | — | — | — |",
            "| EE Release | — | — | — | — | — |",
            "| EE Upgrade | — | — | — | — | — |",
        ]
    else:
        rows = []
        for key, label in [("ee", "EE"), ("de", "DE"), ("ce", "CE")]:
            ed = data.get(key, {})
            rows.append(
                f"| {label} "
                f"| {hc(ed.get('healthy', False))} "
                f"| {ver(ed.get('version_ok', False), ed.get('version_actual', '?'))} "
                f"| {svc(ed.get('services_ok', False))} "
                f"| {ppt(ed.get('puppeteer_failed', 0))} "
                f"| {ds_err(ed.get('ds_log_errors', 0))} |"
            )

        ug = data.get("ee_upgrade", {})

        ver_rel = ug.get("version_release_actual", "?")
        if not ver_rel or ver_rel in ("not set", "not-found"):
            ver_rel = "?"
        jwt_rel = ug.get("jwt_ee_release_exists", False)
        rows.append(
            f"| EE Release "
            f"| {hc(ug.get('healthy_release', False))} "
            f"| {ver_rel} "
            f"| {jwt_flag(jwt_rel, 'YES', 'FAIL')} "
            f"| — "
            f"| — |"
        )

        rows.append(
            f"| EE Upgrade "
            f"| {hc(ug.get('healthy_upgrade', False))} "
            f"| {ver(ug.get('version_ok', False), ug.get('version_actual', '?'))} "
            f"| {jwt_flag(ug.get('jwt_match', False), 'MATCH', 'FAIL')} "
            f"| {ppt(ug.get('puppeteer_failed', 0))} "
            f"| {ds_err(ug.get('ds_log_errors', 0))} |"
        )

    header = (
        "| Edition | Healthcheck | Version | SVC/JWT | Puppeteer (≤5) | DS Log Errors |\n"
        "|---------|-------------|---------|---------|----------------|---------------|"
    )
    return header + "\n" + "\n".join(rows)


BADGE = (
    "[![dev-DEB-x64-arm64]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml/badge.svg?branch=main)]"
    "(https://github.com/igwyd/Instalation-tests/actions/workflows/dev-DEB-x64-arm64.yml)"
)

x64   = load(".github/workflow-results/dev-deb-x64.json")
arm64 = load(".github/workflow-results/dev-deb-arm64.json")

x64_date   = (x64   or {}).get("run_date", "")
arm64_date = (arm64 or {}).get("run_date", "")

sections = [BADGE, ""]
sections.append(f"**x64**{' · ' + x64_date if x64_date else ''}")
sections.append(arch_table(x64))
sections.append("")
sections.append(f"**arm64**{' · ' + arm64_date if arm64_date else ''}")
sections.append(arch_table(arm64))

table = "\n".join(sections)

with open("README.md", encoding="utf-8") as f:
    content = f.read()

new_content = re.sub(
    r"(<!-- deb-status-start -->).*?(<!-- deb-status-end -->)",
    f"\\1\n{table}\n\\2",
    content,
    flags=re.DOTALL,
)

if new_content != content:
    with open("README.md", "w", encoding="utf-8") as f:
        f.write(new_content)
    print("README updated")
else:
    print("No changes to README")
