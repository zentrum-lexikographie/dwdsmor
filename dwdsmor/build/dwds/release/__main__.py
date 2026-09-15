import logging
import lzma
import re
import sys
from os import environ
from pathlib import Path
from subprocess import check_call
from tempfile import NamedTemporaryFile

from dwdsmor.build.gitup import dwdsmor_project, dwdsmor_versions, dwdswb_date
from dwdsmor.build.traversal import traversal_to_csv
from dwdsmor.log import configure_logging

configure_logging()
logger = logging.getLogger("dwdsmor")

date = dwdswb_date()
year, month, day, *_ = re.findall(r"\d+", date)
version = f"{int(year):d}.{int(month):d}.{int(day):d}"

if version in dwdsmor_versions():
    logger.info(f"DWDSmor/DWDS v{version} already built")
    sys.exit(0)

logger.info(f"Building DWDSmor/DWDS v{version}")

project_dir = Path(__file__).parent.parent.parent.parent.parent.resolve()

check_call([sys.executable, "-m", "dwdsmor.build.dwds.wb_download"], cwd=project_dir)

package_dir = project_dir / "lexicon" / "dwds" / "package"
automata_dir = package_dir / "dwdsmor_dwds" / "automata"

check_call(
    [
        sys.executable,
        "-m",
        "dwdsmor.build",
        "--edition",
        "dwds",
        "--automata-dir",
        automata_dir,
    ],
    cwd=project_dir,
)

temp_traversal_csv_file = None
try:
    logger.info("Dumping index automaton traversal")
    with (
        NamedTemporaryFile("wb", delete=False) as tf,
        lzma.open(tf, "wt", encoding="utf-8") as xzf,
    ):
        temp_traversal_csv_file = tf.name
        traversal_to_csv(automata_dir / "index.a", xzf)
    logger.info("Uploading index automaton traversal")
    dwdsmor_project().generic_packages.upload(
        package_name="dwdsmor-dwds-index",
        package_version=version,
        file_name="dwdsmor-dwds-index.csv.xz",
        path=temp_traversal_csv_file,
    )
finally:
    if temp_traversal_csv_file is not None:
        Path(temp_traversal_csv_file).unlink()

(package_dir / "VERSION").write_text(date.replace("-", "."))
check_call([sys.executable, "-m", "build"], cwd=package_dir)

repo_url = environ.get("TWINE_REPO", "")
for whl in (package_dir / "dist").rglob("*.whl"):
    check_call(["twine", "upload", "--repository-url", repo_url, whl.as_posix()])
