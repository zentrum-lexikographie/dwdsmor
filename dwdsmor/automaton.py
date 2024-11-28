"""
Handling of SFST automata/transducer collections on which DWDSmor is based.

For different use cases like lemmatization, paradigm generation or
morphological segmentation, DWDSmor relies on different transducers
based on a common lexicon. Those transducers are stored collectively
in a common local directory from which they can be read and used via
the class ``Automata`` in this module.
"""

__all__ = [
    "detect_dev_root_dir",
    "detect_root_dir",
    "Generator",
    "Analyzer",
    "Automata",
    "automata",
    "Lemmatizer",
    "lemmatizer",
    "load_from_hub",
]

import csv
import lzma
import os
from collections import defaultdict
from dataclasses import dataclass
from os import PathLike
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Union

from dotenv import dotenv_values
from huggingface_hub import snapshot_download
from huggingface_hub.utils import disable_progress_bars, enable_progress_bars
from sfst_transduce import CompactTransducer, Transducer

from .log import logger
from .traversal import Traversal
from .version import __version__

config = {
    **dotenv_values(".env.shared"),
    **dotenv_values(".env"),
    **os.environ,
}


class AutomataDirNotFound(Exception):
    pass


def detect_dev_root_dir():
    """
    Detect development environment and return one of its automaton
    dirs.

    Development environments are flagged via a set environment
    variable ``DWDSMOR_ENV`` (i. e. in ``.env.shared``). In such
    environments, one of the automata in a subdirectory of ``build/``,
    i.e. ``build/open`` is returned.
    """
    if config.get("DWDSMOR_DEV"):
        build_dir = Path("build")
        for edition in ("dwds", "open", "dev"):
            edition_dir = build_dir / edition
            if edition_dir.is_dir():
                return str(edition_dir)
        raise AutomataDirNotFound(
            "$DWDSMOR_DEV is set, but no known automata available under build/"
        )


def detect_root_dir() -> Path:
    """
    Detect local automata directory if none is specified.

    1. Try to get it from an environment variable ``DWDSMOR_AUTOMATA_DIR``.
    2. Try to detect a development environment and get it from there.
    3. Raise ``AutomataDirNotFound``.
    """
    root = config.get("DWDSMOR_AUTOMATA_DIR")
    if root:
        return Path(root)
    root = detect_dev_root_dir()
    if root:
        return Path(root)
    raise AutomataDirNotFound()


@dataclass
class Generator:
    """
    Wrap a SFST transducer for generating strings, i.e. inflection paradigms.
    """

    transducer: Transducer

    def generate(self, s: str) -> Iterable[Traversal]:
        """
        Generate all traversals of a transducer for the given input string.
        """
        return (Traversal.parse(traversal) for traversal in self.transducer.generate(s))


@dataclass
class Analyzer:
    """
    Wrap a SFST transducer providing a morphological analysis of input strings.
    """

    transducer: CompactTransducer

    def analyze(self, s: str) -> Iterable[Traversal]:
        """
        Generate all traversals of a transducer that express
        morphological analyses of an input string.
        """
        return (Traversal.parse(traversal) for traversal in self.transducer.analyse(s))


automaton_types = {"finite", "index", "lemma", "morph", "root"}
traversal_automaton_types = {"index"}


def assert_valid_automaton_type(automaton_type: str, types=automaton_types):
    assert automaton_type in automaton_types, (
        f"{automaton_type} is not a valid automaton_type. "
        f"Supported types: {automaton_types}"
    )


class Automata:
    def __init__(self, root_dir: Optional[Union[str, PathLike]] = None):
        self.root_dir = Path(root_dir) if root_dir else detect_root_dir()

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
        assert_valid_automaton_type(automaton_type)
        return Generator(self.transducer(automaton_type))  # type: ignore

    def analyzer(self, automaton_type="lemma", both_layers=False) -> Analyzer:
        assert_valid_automaton_type(automaton_type)
        return Analyzer(
            self.transducer(
                automaton_type, generate=False, both_layers=both_layers
            )  # type: ignore
        )

    def traversals(self, automaton_type="index") -> Dict[str, List[Traversal]]:
        assert_valid_automaton_type(automaton_type, types=traversal_automaton_types)
        traversals_file = Path(self.root_dir) / f"{automaton_type}.csv.lzma"
        traversals = defaultdict(list)
        with lzma.open(traversals_file, "rt") as traversals_csv:
            for traversal in csv.DictReader(traversals_csv):
                traversal_obj = Traversal(**traversal)
                traversals[traversal_obj.analysis].append(traversal_obj)
        return traversals


default_repo_id = config.get("DWDSMOR_HF_REPO_ID", "zentrum-lexikographie/dwdsmor-open")


def load_from_hub(
    repo_id: Optional[str] = None, revision: Optional[str] = None, **kwargs
):
    repo_id = repo_id or default_repo_id
    revision = revision or f"v{__version__}"
    logger.debug("Load automata from Huggingface repo %s @ %s", repo_id, revision)
    try:
        disable_progress_bars()
        return Automata(snapshot_download(repo_id=repo_id, revision=revision, **kwargs))
    finally:
        enable_progress_bars()


def automata(automata_location: Optional[str] = None, *args, **kwargs):
    if automata_location is not None:
        path = Path(automata_location)
        if path.is_dir():
            logger.debug("Load automata from local dir '%s'", str(path))
            return Automata(path)
    if automata_location is None:
        try:
            detected_dir = detect_root_dir()
            logger.debug(
                "Load automata from detected local dir '%s'", str(detected_dir)
            )
            return Automata(detected_dir)
        except AutomataDirNotFound:
            pass
    return load_from_hub(automata_location, *args, **kwargs)


class Lemmatizer:
    def __init__(self, automata, automaton_type="lemma"):
        self.analyzer = automata.analyzer(automaton_type)

    def __call__(self, word, **criteria):
        traversals = tuple(self.analyzer.analyze(word))
        criteria_stack = list(criteria.items())
        criteria_stack.reverse()
        while criteria_stack:
            attr, attr_vals = criteria_stack.pop()
            filtered = tuple((t for t in traversals if getattr(t, attr) in attr_vals))
            traversals = filtered or traversals
        for traversal in traversals:
            return traversal.analysis


def lemmatizer(*args, **kwargs):
    return Lemmatizer(automata(*args, **kwargs))
