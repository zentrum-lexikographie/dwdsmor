from io import TextIOWrapper
from pathlib import Path
from tempfile import NamedTemporaryFile
from urllib.request import urlopen
from zipfile import ZipFile

import conllu


def download(dataset, git_ref, paths):
    url = (
        f"https://codeload.github.com/UniversalDependencies/{dataset}/"
        f"zip/refs/tags/{git_ref}"
    )
    path_prefix = f"{dataset}-{git_ref}/"
    temp_zip_file = None
    try:
        with NamedTemporaryFile("wb", delete=False) as tf:
            temp_zip_file = tf.name
            with urlopen(url) as f:
                tf.write(f.read())
        with ZipFile(temp_zip_file) as zf:
            for p in paths:
                p = path_prefix + p
                with zf.open(p, "r") as f, TextIOWrapper(f, encoding="utf-8") as tf:
                    for sentence in conllu.parse_incr(tf):
                        yield sentence
    finally:
        if temp_zip_file is not None:
            Path(temp_zip_file).unlink()


def download_hdt():
    return download(
        "UD_German-HDT",
        "r2.16",
        (f"de_hdt-ud-train-{p1}-{p2}.conllu" for p1 in ("a", "b") for p2 in ("1", "2")),
    )


def download_gsd():
    return download("UD_German-GSD", "r2.17", ("de_gsd-ud-train.conllu",))
