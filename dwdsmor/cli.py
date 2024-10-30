import argparse
import sys
from dataclasses import asdict, astuple, dataclass
from itertools import product

from tabulate import tabulate

from dwdsmor import Automata
from dwdsmor.traversal import Traversal, boundary_tags, tags

headers = {
    "word": "Wordform",
    "spec": "Analysis",
    "analysis": "Lemma",
    "segmented": "Segmented Wordform",
    "lidx": "Lemma Index",
    "pidx": "Paradigm Index",
    "process": "Process",
    "means": "Means",
    "pos": "POS",
    "subcat": "Subcategory",
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
    "ellipinfo": "Ellipsis",
    "charinfo": "Characters",
}

noun_tagging = ("gender", "case", "number", "inflection")
verb_tagging = ("number", "tense", "mood")
nonfinite_tagging = ("nonfinite", "tense", "auxiliary")
info_tagging = ("metainfo", "orthinfo")

has_subcat_tagging = {"+ART", "+PPRO"}
has_degree_tagging = {
    "+ADJ",
    "+CARD",
    "+DEM",
    "+INDEF",
    "+ORD",
    "+POSS",
    "+REL",
    "+WPRO",
}
has_function_tagging = {"+ART", *has_degree_tagging}
has_person_tagging = {"+PPRO", "+V"}


def get_taggings(pos, with_info=False):
    preamble = []
    if pos in has_subcat_tagging:
        preamble.append("subcat")
    if pos in has_degree_tagging:
        preamble.append("degree")
    if pos in has_function_tagging:
        preamble.append("function")
    if pos in has_person_tagging:
        preamble.append("person")

    preamble = tuple(preamble)
    coda = info_tagging if with_info else tuple()

    if pos == "+V":
        tagging = (preamble + verb_tagging + coda, preamble + nonfinite_tagging + coda)
    elif pos in {"+ART", "+NN", "+NPROP", "+PPRO"}:
        tagging = (preamble + noun_tagging + coda,)
    else:
        tagging = (preamble + noun_tagging + coda, preamble + nonfinite_tagging + coda)

    for tagging_pattern in tagging:
        for tagging in product(*((tags[tt] | {None}) for tt in tagging_pattern)):
            yield tuple((t for t in tagging if t is not None))


@dataclass
class Result(Traversal):
    word: str | None = None

    @staticmethod
    def from_traversal(traversal: Traversal, word):
        return Result(**asdict(traversal), word=word)

    @staticmethod
    def from_spec(spec: str, word: str):
        return Result(**asdict(Traversal.parse(spec)), word=word)


def main():
    arg_parser = argparse.ArgumentParser(description="Traverse DWDSmor automata.")
    arg_parser.add_argument("-g", "--generate", help="Generate", action="store_true")
    arg_parser.add_argument("words", nargs="*")
    args = arg_parser.parse_args()

    results = []
    automata = Automata()

    if args.generate:
        analyzer = automata.analyzer("index")
        generator = automata.generator("index")
        for word in args.words:
            base_specs = set()
            for traversal in analyzer.analyze(word):
                traversal = traversal.reparse(visible_boundaries=boundary_tags)
                base_spec = traversal.analysis
                for base_tagging in ["lidx", "pidx", "pos"]:
                    tag = getattr(traversal, base_tagging)
                    if tag is not None:
                        base_spec += f"<{tag}>"
                base_specs.add((traversal.pos, base_spec))
            for pos, base_spec in sorted(base_specs):
                for tagging in get_taggings(pos):
                    spec = base_spec + "".join(f"<{tag}>" for tag in tagging)
                    for generated in generator.generate(spec):
                        results.append(Result.from_spec(spec, generated.spec))
    else:
        analyzer = automata.analyzer("lemma")
        for word in args.words:
            max_boundaries = {}
            for traversal in analyzer.analyze(word):
                with_boundaries = traversal.reparse(
                    visible_boundaries=boundary_tags, boundary_tag="|"
                )
                boundaries = with_boundaries.analysis.count("|")
                # group by traversal props, leaving out discriminating
                # spec, which expresses boundaries
                group_by = astuple(traversal)[1:]
                if max_boundaries.get(group_by, -1) < boundaries:
                    max_boundaries[group_by] = boundaries
                    results.append(Result.from_traversal(traversal, word))

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
        *(tt for tt in tags.keys() if has_value(tt)),
    ]

    print(
        tabulate(
            [[getattr(r, c) for c in cols] for r in results],
            headers=[headers.get(c, c) for c in cols],
            tablefmt="github",
        )
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
