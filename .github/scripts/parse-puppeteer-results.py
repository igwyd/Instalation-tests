#!/usr/bin/env python3
"""Parse puppeteer test reports and write results to GITHUB_ENV / GITHUB_OUTPUT.

Reports OK / FAILED / TOTAL counts (per provider and combined) so that a cycle
where tests silently did not run (TOTAL == 0) is distinguishable from one where
all tests passed.

Usage:
  python3 parse-puppeteer-results.py                  # single run
  python3 parse-puppeteer-results.py --edition EE     # multi-edition (EE/DE/CE)
"""
import os
import re
import sys


def count_results(path):
    """Return (ok, err) counts from a puppeteer report. Missing report -> (0, 0),
    i.e. TOTAL == 0, which downstream treats as 'nothing ran' (a failure)."""
    if not os.path.exists(path):
        print(f"Report not found: {path}")
        return 0, 0
    with open(path) as f:
        content = f.read()
    ok = 0
    err = 0
    # Report table columns: Test Name | Start Time | Execution Time | Status | ...
    # Status is always the 4th <td> (index 3) in each data row.
    for row in re.findall(r'<tr[^>]*>(.*?)</tr>', content, re.DOTALL):
        cells = re.findall(r'<td>(.*?)</td>', row, re.DOTALL)
        if len(cells) >= 4:
            status = cells[3].strip()
            if status == "OK":
                ok += 1
            elif status:
                err += 1
    return ok, err


api_ok,  api_err  = count_results("Dep.Tests/puppeteer/out/example/report.html")
wopi_ok, wopi_err = count_results("Dep.Tests/puppeteer/out/wopi/report.html")

api_total  = api_ok  + api_err
wopi_total = wopi_ok + wopi_err
total_ok   = api_ok  + wopi_ok
total_err  = api_err + wopi_err
total_all  = total_ok + total_err

edition = None
args = sys.argv[1:]
if "--edition" in args:
    idx = args.index("--edition")
    if idx + 1 < len(args):
        edition = args[idx + 1]

print(f"API tests:  OK={api_ok},  Failed={api_err},  Total={api_total}")
print(f"WOPI tests: OK={wopi_ok}, Failed={wopi_err}, Total={wopi_total}")
print(f"Total:      OK={total_ok}, Failed={total_err}, Total={total_all}")

github_env = os.environ.get("GITHUB_ENV")
if edition:
    if github_env:
        with open(github_env, "a") as f:
            f.write(f"PUPPETEER_{edition}_API_OK={api_ok}\n")
            f.write(f"PUPPETEER_{edition}_API_FAILED={api_err}\n")
            f.write(f"PUPPETEER_{edition}_API_TOTAL={api_total}\n")
            f.write(f"PUPPETEER_{edition}_WOPI_OK={wopi_ok}\n")
            f.write(f"PUPPETEER_{edition}_WOPI_FAILED={wopi_err}\n")
            f.write(f"PUPPETEER_{edition}_WOPI_TOTAL={wopi_total}\n")
            f.write(f"PUPPETEER_{edition}_OK={total_ok}\n")
            f.write(f"PUPPETEER_{edition}_FAILED={total_err}\n")
            f.write(f"PUPPETEER_{edition}_TOTAL={total_all}\n")
else:
    if github_env:
        with open(github_env, "a") as f:
            f.write(f"PUPPETEER_API_OK={api_ok}\n")
            f.write(f"PUPPETEER_API_FAILED={api_err}\n")
            f.write(f"PUPPETEER_API_TOTAL={api_total}\n")
            f.write(f"PUPPETEER_WOPI_OK={wopi_ok}\n")
            f.write(f"PUPPETEER_WOPI_FAILED={wopi_err}\n")
            f.write(f"PUPPETEER_WOPI_TOTAL={wopi_total}\n")
            f.write(f"PUPPETEER_OK={total_ok}\n")
            f.write(f"PUPPETEER_FAILED={total_err}\n")
            f.write(f"PUPPETEER_TOTAL={total_all}\n")

    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a") as f:
            f.write(f"puppeteer_ok={total_ok}\n")
            f.write(f"puppeteer_api_failed={api_err}\n")
            f.write(f"puppeteer_wopi_failed={wopi_err}\n")
            f.write(f"puppeteer_failed={total_err}\n")
            f.write(f"puppeteer_total={total_all}\n")
