__all__ = [
    "transducer",
    "analyzer",
    "Analyzer",
    "generator",
    "Generator",
    "traversals",
    "lemmatizer",
    "Lemmatizer",
    "automaton_types",
    "edition",
    "__version__",
]

import csv
import logging
import lzma
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Union

from sfst_transduce import CompactTransducer, Transducer

from .traversal import Traversal
from .version import __version__

logger = logging.getLogger("dwdsmor")

default_automata_dir = Path(__file__).parent / "automata"
try:
    import dwdsmor_dwds  # type: ignore

    default_automata_dir = Path(dwdsmor_dwds.__file__).parent / "automata"
except ModuleNotFoundError:
    pass

edition_file = default_automata_dir / "EDITION"

edition = "n/a"
if edition_file.is_file():
    edition = edition_file.read_text()


@dataclass
class Generator:
    """
    Wrap a SFST transducer for generating strings, i.e. inflection paradigms.
    """

    transducer: Transducer

    def generate(
        self,
        s: str,
        visible_boundaries="",
        boundary_tag=None,
        join_tags=False,
        idx_to_int=False,
    ) -> Iterable[Traversal]:
        """
        Generate all traversals of a transducer for the given input string.
        """
        return (
            Traversal.parse(
                traversal,
                visible_boundaries=visible_boundaries,
                boundary_tag=boundary_tag,
                join_tags=join_tags,
                idx_to_int=idx_to_int,
            )
            for traversal in self.transducer.generate(s)
        )


@dataclass
class Analyzer:
    """
    Wrap a SFST transducer providing a morphological analysis of input strings.
    """

    transducer: CompactTransducer

    def analyze(
        self,
        s: str,
        visible_boundaries="",
        boundary_tag=None,
        join_tags=False,
        idx_to_int=False,
    ) -> Iterable[Traversal]:
        """
        Generate all traversals of a transducer that express
        morphological analyses of an input string.
        """
        return (
            Traversal.parse(
                traversal,
                visible_boundaries=visible_boundaries,
                boundary_tag=boundary_tag,
                join_tags=join_tags,
                idx_to_int=idx_to_int,
            )
            for traversal in self.transducer.analyse(s)
        )


automaton_types = ("lemma", "lemma2", "finite", "root", "root2", "index")
traversal_automaton_types = ("index",)


def assert_valid_automaton_type(automaton_type: str, types=automaton_types):
    assert automaton_type in automaton_types, (
        f"{automaton_type} is not a valid automaton_type. "
        f"Supported types: {automaton_types}"
    )


def transducer(
    automaton_type="lemma",
    automata_dir=default_automata_dir,
    generate=True,
    both_layers=False,
) -> Union[Transducer, CompactTransducer]:
    file_suffix = "a" if generate else "ca"
    transducer_file = automata_dir / f"{automaton_type}.{file_suffix}"
    assert transducer_file.is_file(), f"{transducer_file} does not exist"
    if not generate:
        transducer = CompactTransducer(transducer_file.as_posix())
        transducer.both_layers = both_layers
        return transducer
    else:
        return Transducer(transducer_file.as_posix())


def generator(
    automaton_type="index",
    automata_dir=default_automata_dir,
) -> Generator:
    assert_valid_automaton_type(automaton_type)
    return Generator(transducer(automaton_type, automata_dir))  # type: ignore


def analyzer(
    automaton_type="lemma", automata_dir=default_automata_dir, both_layers=False
) -> Analyzer:
    assert_valid_automaton_type(automaton_type)
    return Analyzer(
        transducer(
            automaton_type, automata_dir, generate=False, both_layers=both_layers
        )
    )  # type: ignore


def traversals(
    automaton_type="index", automata_dir=default_automata_dir
) -> Dict[str, List[Traversal]]:
    assert_valid_automaton_type(automaton_type, types=traversal_automaton_types)
    traversals_file = automata_dir / f"{automaton_type}.csv.xz"
    traversals = defaultdict(list)
    with lzma.open(traversals_file, "rt") as traversals_csv:
        for traversal in csv.DictReader(traversals_csv):
            del traversal["inflected"]
            traversal_obj = Traversal(**traversal)
            traversals[traversal_obj.analysis].append(traversal_obj)
    return traversals


class Lemmatizer:
    def __init__(self, automaton_type="lemma", automata_dir=default_automata_dir):
        self.analyzer = analyzer(automaton_type, automata_dir)

    def __call__(self, word, **criteria):
        traversals = tuple(self.analyzer.analyze(word))
        criteria_stack = list((k, v) for k, v in criteria.items() if v)
        criteria_stack.reverse()
        while criteria_stack:
            if len(traversals) == 1:
                break
            attr, attr_vals = criteria_stack.pop()
            filtered = tuple((t for t in traversals if getattr(t, attr) in attr_vals))
            traversals = filtered or traversals
        traversals = sorted(traversals, key=lambda t: len(t.spec))
        for traversal in traversals:
            return traversal


def lemmatizer(automaton_type="lemma", automata_dir=default_automata_dir):
    return Lemmatizer(automaton_type, automata_dir)
