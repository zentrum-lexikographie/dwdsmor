import argparse
import csv
import subprocess
from pathlib import Path

from ..tag import all_tags
from ..traversal import Traversal
from ..util import inflected


def traverse(automata_file, sorted=False):
    traversals = subprocess.Popen(
        ["fst-generate", "-b", automata_file.as_posix()],
        encoding=("utf-8" if not sorted else None),
        stdout=subprocess.PIPE,
    )
    if sorted:
        traversals = subprocess.Popen(
            ["sort", "-u"],
            encoding="utf-8",
            stdin=traversals.stdout,
            stdout=subprocess.PIPE,
        )

    with traversals:
        for traversal_str in traversals.stdout:
            yield traversal_str.split()


def traversal_to_csv(automata_file, csv_file):
    table = csv.writer(csv_file)
    table.writerow(
        [
            "spec",
            "analysis",
            "surface",
            "inflected",
            *all_tags,
        ]
    )
    for surface, spec in traverse(automata_file, sorted=True):
        traversal = Traversal.parse(spec)
        table.writerow(
            [
                spec,
                traversal.analysis,
                surface,
                inflected(spec, surface),
                *(getattr(traversal, tt) for tt in all_tags),
            ]
        )


arg_parser = argparse.ArgumentParser(description="Traverse DWDSmor automaton.")
arg_parser.add_argument(
    "-i",
    "--input-file",
    help="DWDSmor automata to traverse",
    type=Path,
    required=True,
)
arg_parser.add_argument(
    "-o",
    "--output-file",
    help="output CoNLL-U file with (updated) annotations",
    type=argparse.FileType("w"),
    default="-",
)


if __name__ == "__main__":
    args = arg_parser.parse_args()
    traversal_to_csv(args.input_file, args.output_file)
