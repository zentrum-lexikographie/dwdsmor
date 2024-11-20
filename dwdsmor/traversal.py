from dataclasses import dataclass

from dwdsmor.tag import boundary_tags, tag_types


@dataclass
class Traversal:
    spec: str
    surface: str
    analysis: str
    lidx: str | None = None
    pidx: str | None = None
    pos: str | None = None
    category: str | None = None
    degree: str | None = None
    function: str | None = None
    person: str | None = None
    gender: str | None = None
    case: str | None = None
    number: str | None = None
    nonfinite: str | None = None
    tense: str | None = None
    mood: str | None = None
    auxiliary: str | None = None
    inflection: str | None = None
    metainfo: str | None = None
    orthinfo: str | None = None
    charinfo: str | None = None
    ellipinfo: str | None = None
    processes: str | None = None
    means: str | None = None

    def reparse(self, **args):
        return Traversal.parse(self.spec, **args)

    @staticmethod
    def parse_label(s, visible_boundaries, boundary_tag):
        c = s[0]
        if c != "<" and c != ":":
            return "", c, s[1:]
        elif c == "<":
            e = s.find(">")
            assert e > 0
            tag = s[1:e]
            s = s[e + 1 :]
            if tag == "":
                return "", "", s
            elif tag in visible_boundaries:
                return ("", boundary_tag or f"<{tag}>", s)
            elif tag in boundary_tags:
                return ("", "", s)
            else:
                return tag_types[tag], tag, s

    @staticmethod
    def parse(s, visible_boundaries="", boundary_tag=None):
        spec = s
        surface = ""
        analysis = ""
        tags = {}
        while s:
            if s.startswith(r"\:"):
                surface += ":"
                analysis += ":"
                s = s[2:]
                continue
            k, v, s = Traversal.parse_label(s, visible_boundaries, boundary_tag)
            if k:
                tags[k] = v
            else:
                analysis += v
            if s.startswith(":"):
                k, v, s = Traversal.parse_label(s[1:], visible_boundaries, boundary_tag)
                if k:
                    tags[k] = v
                else:
                    surface += v
            elif not k:
                surface += v
        return Traversal(spec, surface, analysis, **tags)
