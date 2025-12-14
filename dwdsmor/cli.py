import argparse
from dataclasses import asdict, astuple, dataclass
from itertools import product

from tabulate import tabulate
from tqdm import tqdm

import dwdsmor

from . import edition
from .log import configure_logging
from .tag import (
    all_tags,
    boundary_tags,
    inflection_tag_seqs,
    info_tags,
    lexeme_tags,
    tag_values,
)
from .traversal import Traversal
from .util import inflected
from .version import __version__

headers = {
    "word": "Wordform",
    "spec": "Analysis",
    "analysis": "Lemma",
    "segmented": "Segmented Wordform",
    "weights": "Weights",
    "lidx": "Lemma Index",
    "pidx": "Paradigm Index",
    "processes": "Processes",
    "means": "Means",
    "pos": "POS",
    "category": "Subcategory",
    "auxiliary": "Auxiliary",
    "degree": "Degree",
    "person": "Person",
    "gender": "Gender",
    "case": "Case",
    "number": "Number",
    "inflection": "Inflection",
    "nonfinite": "Nonfinite",
    "function": "Function",
    "mood": "Mood",
    "tense": "Tense",
    "metainfo": "Metalinguistic",
    "orthinfo": "Orthography",
    "syninfo": "Syntax",
    "ellipinfo": "Ellipsis",
    "charinfo": "Characters",
}


def get_taggings(pos, with_info=False):
    tag_seqs = inflection_tag_seqs.get(pos) or inflection_tag_seqs.get("")
    if with_info:
        tag_seqs(ts + info_tags for ts in tag_seqs)

    taggings = set()
    for tag_seq in tag_seqs:
        tagging_values = []
        for tag_type in tag_seq:
            tag_type_values = (
                tag_values.get(pos, dict()).get(tag_type) or tag_values[""][tag_type]
            )
            tagging_values.append(tag_type_values | {None})
        for tagging in product(*tagging_values):
            taggings.add(tuple((t for t in tagging if t is not None)))
    return taggings


@dataclass
class Result(Traversal):
    word: str | None = None

    @staticmethod
    def from_traversal(traversal: Traversal, word):
        return Result(**asdict(traversal), word=word)

    @staticmethod
    def from_spec(spec: str, word: str, idx_to_int=False):
        return Result(**asdict(Traversal.parse(spec, idx_to_int=idx_to_int)), word=word)


def main():
    arg_parser = argparse.ArgumentParser(description="Traverse DWDSmor automata.")
    arg_parser.add_argument(
        "-t", "--automaton-type", choices=dwdsmor.automaton_types, help="automaton type"
    )
    arg_parser.add_argument("-g", "--generate", help="generate", action="store_true")
    arg_parser.add_argument(
        "-q", "--quiet", help="do not report progress", action="store_true"
    )
    arg_parser.add_argument(
        "-v", "--version", help="show version and exit", action="store_true"
    )
    arg_parser.add_argument("words", nargs="*")
    args = arg_parser.parse_args()
    configure_logging()

    if args.version:
        print(f"DWDSmor v{__version__} (edition: {edition})")
        return 0

    results = []

    automaton = "index" if args.generate else "lemma"
    automaton = args.automaton_type if args.automaton_type else automaton

    visible_boundaries = "+" if automaton == "root" or automaton == "root2" else ""
    boundary_tag = " + " if automaton == "root" or automaton == "root2" else None
    idx_to_int = True if automaton == "index" else False
    join_tags = True

    if args.generate:
        analyzer = dwdsmor.analyzer(automaton)
        generator = dwdsmor.generator(automaton)
        for word in args.words:
            lexeme_specs = set()
            for traversal in analyzer.analyze(word):
                traversal = traversal.reparse(visible_boundaries=boundary_tags)
                lexeme_spec = traversal.analysis
                for lexeme_tag in lexeme_tags:
                    tag = getattr(traversal, lexeme_tag)
                    if tag is not None:
                        lexeme_spec += f"<{tag}>"
                lexeme_specs.add((traversal.pos, lexeme_spec))
            for pos, lexeme_spec in sorted(lexeme_specs):
                local_results = []
                taggings = get_taggings(pos)
                if not args.quiet:
                    taggings = tqdm(
                        taggings,
                        desc=f"Inflection patterns ({pos})",
                        total=len(taggings),
                    )
                for tagging in taggings:
                    spec = lexeme_spec + "".join(f"<{tag}>" for tag in tagging)
                    for generated in generator.generate(spec):
                        infl_form = inflected(spec, generated.spec)
                        local_results.append(
                            Result.from_spec(spec, infl_form, idx_to_int=idx_to_int)
                        )
                local_results = sorted(local_results, key=lambda r: r.spec)
                results.extend(local_results)
    else:
        analyzer = dwdsmor.analyzer(automaton)
        for word in args.words:
            local_results = []
            max_boundaries = {}
            for traversal in analyzer.analyze(
                word,
                visible_boundaries=visible_boundaries,
                boundary_tag=boundary_tag,
                idx_to_int=idx_to_int,
                join_tags=join_tags,
            ):
                with_boundaries = traversal.reparse(
                    visible_boundaries=boundary_tags, boundary_tag="|"
                )
                boundaries = with_boundaries.analysis.count("|")
                # group by traversal props, leaving out discriminating
                # spec, which expresses boundaries
                group_by = astuple(traversal)[1:]
                if max_boundaries.get(group_by, -1) < boundaries:
                    max_boundaries[group_by] = boundaries
                    local_results.append(Result.from_traversal(traversal, word))
            local_results = sorted(local_results, key=lambda r: r.spec)
            results.extend(local_results)

    if not results:
        return 1

    def has_value(tag_type, results=results):
        for result in results:
            if getattr(result, tag_type) is not None:
                return True
        return False

    cols = [
        "word",
        "analysis",
        "spec",
        *(tt for tt in all_tags if has_value(tt)),
    ]

    print(
        tabulate(
            [[getattr(r, c) for c in cols] for r in results],
            headers=[headers.get(c, c) for c in cols],
            tablefmt="tsv",
        )
    )

    return 0
