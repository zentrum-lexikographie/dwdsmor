import gzip
from io import BytesIO
from pathlib import Path
from shutil import copyfileobj

import dwdswb

project_dir = Path(__file__).parent.parent.parent
lexicon_dir = project_dir / "lexicon" / "dwds" / "wb"
lexicon_file = lexicon_dir / "dwdswb.xml"


def main():
    lexicon_dir.mkdir(parents=True, exist_ok=True)
    with gzip.open(BytesIO(dwdswb.dataset())) as src, lexicon_file.open("wb") as dest:
        copyfileobj(src, dest)


if __name__ == "__main__":
    main()
