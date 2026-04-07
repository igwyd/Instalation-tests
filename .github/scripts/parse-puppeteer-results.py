#!/usr/bin/env python3
"""Parse puppeteer test reports and write results to GITHUB_ENV / GITHUB_OUTPUT.

Usage:
  python3 parse-puppeteer-results.py                  # single run
  python3 parse-puppeteer-results.py --edition EE     # multi-edition (EE/DE/CE)
"""
import os
import sys


def count_results(path):
    if not os.path.exists(path):
        print(f"Report not found: {path}")
        return 0, 0
    with open(path) as f:
        content = f.read()
    ok  = content.count("<td>OK</td>")
    err = content.count("<td>Error in script terminal.</td>")
    return ok, err


api_ok,  api_err  = count_results("Dep.Tests/puppeteer/out/example/report.html")
wopi_ok, wopi_err = count_results("Dep.Tests/puppeteer/out/wopi/report.html")

total_ok  = api_ok  + wopi_ok
total_err = api_err + wopi_err

edition = None
args = sys.argv[1:]
if "--edition" in args:
    idx = args.index("--edition")
    if idx + 1 < len(args):
        edition = args[idx + 1]

if edition:
    print(f"{edition} API tests:  OK={api_ok},  Failed={api_err}")
    print(f"{edition} WOPI tests: OK={wopi_ok}, Failed={wopi_err}")
    print(f"{edition} Total:      OK={total_ok}, Failed={total_err}")

    prev_total = int(os.environ.get("PUPPETEER_TOTAL_FAILED", "0"))
    new_total = prev_total + total_err

    github_env = os.environ.get("GITHUB_ENV")
    if github_env:
        with open(github_env, "a") as f:
            f.write(f"PUPPETEER_{edition}_FAILED={total_err}\n")
            f.write(f"PUPPETEER_TOTAL_FAILED={new_total}\n")
else:
    print(f"API tests:  OK={api_ok},  Failed={api_err}")
    print(f"WOPI tests: OK={wopi_ok}, Failed={wopi_err}")
    print(f"Total:      OK={total_ok}, Failed={total_err}")

    github_env = os.environ.get("GITHUB_ENV")
    if github_env:
        with open(github_env, "a") as f:
            f.write(f"PUPPETEER_API_FAILED={api_err}\n")
            f.write(f"PUPPETEER_WOPI_FAILED={wopi_err}\n")
            f.write(f"PUPPETEER_FAILED={total_err}\n")

    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a") as f:
            f.write(f"puppeteer_api_failed={api_err}\n")
            f.write(f"puppeteer_wopi_failed={wopi_err}\n")
            f.write(f"puppeteer_failed={total_err}\n")
