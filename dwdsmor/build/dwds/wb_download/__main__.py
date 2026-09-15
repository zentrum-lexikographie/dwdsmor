import gzip
import logging
from io import BytesIO
from pathlib import Path
from shutil import copyfileobj

from dwdsmor.build.gitup import dwdswb_project, dwdswb_date
from dwdsmor.log import configure_logging

configure_logging()

project_dir = Path(__file__).parent.parent.parent.parent.parent
lexicon_dir = project_dir / "lexicon" / "dwds" / "wb"
lexicon_dir.mkdir(parents=True, exist_ok=True)
lexicon_file = lexicon_dir / "dwdswb.xml"

date = dwdswb_date()

logger = logging.getLogger("dwdsmor")
logger.info(f"Downloading DWDSwb @ {date}")

content = dwdswb_project().generic_packages.download(
    package_name="dwdswb", package_version=date, file_name="dwdswb.xml.gz"
)
with gzip.open(BytesIO(content)) as src, lexicon_file.open("wb") as dest:
    copyfileobj(src, dest)
