import os
import tarfile
import subprocess
import datetime

def get_version():
    version_file = os.path.join(os.getcwd(), "version")
    if not os.path.exists(version_file):
        raise FileNotFoundError("version file not found")
    with open(version_file, "r") as f:
        return f.read().strip()

def get_git_info():
    try:
        branch = subprocess.check_output(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            stderr=subprocess.DEVNULL
        ).decode("utf-8").strip()
        commit = subprocess.check_output(
            ["git", "rev-parse", "--short", "HEAD"],
            stderr=subprocess.DEVNULL
        ).decode("utf-8").strip()
        return branch, commit
    except subprocess.CalledProcessError:
        raise RuntimeError("Git repository not found or Git command failed")

def sanitize_filename_part(part):
    return part.replace("/", "_").replace(" ", "_")

def create_archive():
    version = sanitize_filename_part(get_version())
    branch, commit_hash = get_git_info()
    branch = sanitize_filename_part(branch)
    commit_hash = sanitize_filename_part(commit_hash)
    date_str = datetime.datetime.now().strftime("%Y-%m-%d")

    archive_name = f"build_tools-{version}-{branch}-{commit_hash}-{date_str}.tar.gz"

    out_dir = "out"
    if not os.path.isdir(out_dir):
        raise FileNotFoundError(f"Directory '{out_dir}' does not exist.")

    with tarfile.open(archive_name, "w:gz") as tar:
        tar.add(out_dir, arcname=os.path.basename(out_dir))

    print(f"✅ Archive created: {archive_name}")

if __name__ == "__main__":
    create_archive()