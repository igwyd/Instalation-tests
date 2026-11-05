// Diagnostic for "net::ERR_BLOCKED_BY_CLIENT": can Chrome on this runner open the Docs url the tests use?
// Usage: node chrome-nav-diag.js <url>   (puppeteer is taken from NODE_PATH, e.g. Dep.Tests/puppeteer/engine/node_modules)
// Prints the Chrome version, managed policies and the result of a plain navigation in a few variants, with every
// failed request (url + errorText). Never fails the job.
const { execSync } = require("child_process");
const fs = require("fs");

const url = process.argv[2];
if (!url) {
    console.log("usage: node chrome-nav-diag.js <url>");
    process.exit(0);
}

function sh(cmd) {
    try {
        return execSync(cmd, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"], timeout: 20000 }).trim();
    } catch (error) {
        return `(${cmd} failed: ${String(error.message).split("\n")[0]})`;
    }
}

function tryRequire(name) {
    try {
        return require(name);
    } catch {
        return null;
    }
}

const puppeteer = tryRequire("puppeteer") || tryRequire("puppeteer-core");
if (!puppeteer) {
    console.log("puppeteer is not installed, nothing to check");
    process.exit(0);
}

const launchBase = process.env.CHROME_PATH
    ? { executablePath: process.env.CHROME_PATH }
    : { channel: "chrome" };

const variants = [
    { name: "plain", url, args: [] },
    { name: "trailing slash", url: url.replace(/\/?$/, "/"), args: [] },
    { name: "no HTTPS upgrades", url, args: ["--disable-features=HttpsUpgrades,HttpsFirstBalancedModeAutoEnable"] },
    { name: "no safe browsing / extensions", url, args: ["--disable-extensions", "--safebrowsing-disable-auto-update", "--disable-component-update"] },
];

(async () => {
    console.log("url:", url);
    console.log("chrome:", sh("google-chrome --version"));
    console.log("policies:\n" + sh("ls -laR /etc/opt/chrome/policies /etc/chromium/policies 2>&1 | head -20"));
    for (const dir of ["/etc/opt/chrome/policies/managed", "/etc/chromium/policies/managed"]) {
        if (fs.existsSync(dir)) {
            for (const f of fs.readdirSync(dir)) console.log(`${dir}/${f}:\n` + fs.readFileSync(`${dir}/${f}`, "utf8").slice(0, 1500));
        }
    }
    console.log("curl:", sh(`curl -sS -m 15 -o /dev/null -w "%{http_code} %{redirect_url}" ${url}`));

    for (const variant of variants) {
        let browser;
        try {
            browser = await puppeteer.launch({ ...launchBase, headless: true, args: ["--no-sandbox", ...variant.args] });
            const page = await browser.newPage();
            const failures = [];
            page.on("requestfailed", (request) => failures.push(`${request.url()} -> ${request.failure()?.errorText}`));
            try {
                const response = await page.goto(variant.url, { waitUntil: "domcontentloaded", timeout: 15000 });
                console.log(`[${variant.name}] OK ${response?.status()} ${page.url()}`);
            } catch (error) {
                console.log(`[${variant.name}] FAIL ${variant.url}: ${error.message}`);
            }
            if (failures.length) console.log(`[${variant.name}] failed requests:\n  ` + failures.slice(0, 10).join("\n  "));
        } catch (error) {
            console.log(`[${variant.name}] launch error: ${error.message}`);
        } finally {
            if (browser) await browser.close().catch(() => {});
        }
    }
})().catch((error) => console.log("diag error:", error.message));
