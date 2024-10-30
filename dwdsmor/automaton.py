# download template:
#
# https://github.com/flairNLP/flair/blob/master/flair/file_utils.py#L228-L274

import csv
import lzma
import os
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Iterable, List, Union

from dotenv import dotenv_values
from sfst_transduce import CompactTransducer, Transducer

from dwdsmor.traversal import Traversal

config = {
    **dotenv_values(".env.shared"),
    **dotenv_values(".env"),
    **os.environ,
}


def detect_dev_root_dir():
    if config.get("DWDSMOR_DEV"):
        build_dir = Path("build")
        for edition in ("dwds", "open", "dev"):
            edition_dir = build_dir / edition
            if edition_dir.is_dir():
                return str(edition_dir)
    raise RuntimeError("$DWDSMOR_DEV is set, but no automata available under build/")


def get_default_root_dir() -> Path:
    root = config.get("DWDSMOR_AUTOMATA_ROOT")
    if root:
        return Path(root)
    root = detect_dev_root_dir()
    if root:
        return Path(root)
    else:
        return Path(Path.home(), ".dwdsmor")


@dataclass
class Generator:
    transducer: Transducer

    def generate(self, s: str) -> Iterable[Traversal]:
        return (Traversal.parse(traversal) for traversal in self.transducer.generate(s))


@dataclass
class Analyzer:
    transducer: CompactTransducer

    def analyze(self, s: str) -> Iterable[Traversal]:
        return (Traversal.parse(traversal) for traversal in self.transducer.analyse(s))


@dataclass
class Automata:
    root_dir: Path = field(default_factory=get_default_root_dir)

    def transducer(
        self, automaton_type="lemma", generate=True, both_layers=False
    ) -> Union[Transducer, CompactTransducer]:
        file_suffix = "a" if generate else "ca"
        transducer_file = Path(self.root_dir) / f"{automaton_type}.{file_suffix}"
        assert transducer_file.is_file(), f"{transducer_file} does not exist"
        if not generate:
            transducer = CompactTransducer(transducer_file.as_posix())
            transducer.both_layers = both_layers
            return transducer
        else:
            return Transducer(transducer_file.as_posix())

    def generator(self, automaton_type="index") -> Generator:
        return Generator(self.transducer(automaton_type))  # type: ignore

    def analyzer(self, automaton_type="lemma", both_layers=False) -> Analyzer:
        return Analyzer(
            self.transducer(
                automaton_type, generate=False, both_layers=both_layers
            )  # type: ignore
        )

    def traversals(self, automaton_type="index") -> Dict[str, List[Traversal]]:
        traversals_file = Path(self.root_dir) / f"{automaton_type}.csv.lzma"
        traversals = defaultdict(list)
        with lzma.open(traversals_file, "rt") as traversals_csv:
            for traversal in csv.DictReader(traversals_csv):
                traversal_obj = Traversal(**traversal)
                traversals[traversal_obj.analysis].append(traversal_obj)
        return traversals
