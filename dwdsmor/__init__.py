import re
from collections import namedtuple
from functools import cached_property

PROCESSES = ["COMP", "DER", "CONV"]

MEANS = ["concat", "hyph", "ident", "pref", "prev", "suff"]

Component = namedtuple("Component", ["lemma", "tags"])


class Analysis(tuple):
    def __new__(cls, analysis, components):
        inst = tuple.__new__(cls, components)
        inst.analysis = analysis
        return inst

    @cached_property
    def lemma(self):
        lemma = "".join(analysis.lemma for analysis in self)
        return lemma

    @cached_property
    def seg_lemma(self):
        analysis = self.analysis
        for process in PROCESSES:
            analysis = re.sub("<" + process + ">", "", analysis)
        for means in MEANS:
            analysis = re.sub(
                "<" + means + r"(?:\([^>]+\))?(?:\|[^>]+)?" + ">", "", analysis
            )
        analysis = re.sub(r"(?:<IDX[1-8]>)?", "", analysis)
        analysis = re.sub(r"(?:<PAR[1-8]>)?", "", analysis)
        analysis = re.sub(r"<\+[^>]+>.*", "", analysis)
        if analysis == r"\:":
            analysis = ":"
        return analysis

    @cached_property
    def tags(self):
        tags = [tag for analysis in self for tag in analysis.tags]
        return tags

    @cached_property
    def lemma_index(self):
        return next(
            (int(tag[3:]) for tag in self.tags if re.fullmatch(r"IDX[1-8]", tag)), None
        )

    @cached_property
    def paradigm_index(self):
        return next(
            (int(tag[3:]) for tag in self.tags if re.fullmatch(r"PAR[1-8]", tag)), None
        )

    @cached_property
    def pos(self):
        return next((tag[1:] for tag in self.tags if re.match(r"\+.", tag)), None)

    @cached_property
    def process(self):
        if [tag for tag in self.tags if tag in PROCESSES]:
            return "∘".join(tag for tag in reversed(self.tags) if tag in PROCESSES)

    @cached_property
    def means(self):
        if [
            tag
            for tag in self.tags
            if re.sub(r"(?:\(.+\))?(?:\|.+)?", "", tag) in MEANS
        ]:
            return "∘".join(
                tag
                for tag in reversed(self.tags)
                if re.sub(r"(?:\(.+\))?(?:\|.+)?", "", tag) in MEANS
            )

    _subcat_tags = {
        "Pers": True,
        "Refl": True,
        "Rec": True,
        "Def": True,
        "Indef": True,
        "Neg": True,
        "Coord": True,
        "Sub": True,
        "InfCl": True,
        "AdjPos": True,
        "AdjComp": True,
        "AdjSup": True,
        "Comma": True,
        "Period": True,
        "Ellip": True,
        "Quote": True,
        "Paren": True,
        "Dash": True,
        "Slash": True,
        "Other": True,
    }

    _auxiliary_tags = {"haben": True, "sein": True}

    _degree_tags = {"Pos": True, "Comp": True, "Sup": True}

    _person_tags = {"1": True, "2": True, "3": True, "Invar": True}

    _gender_tags = {
        "Fem": True,
        "Neut": True,
        "Masc": True,
        "NoGend": True,
        "Invar": True,
    }

    _case_tags = {"Nom": True, "Gen": True, "Dat": True, "Acc": True, "Invar": True}

    _number_tags = {"Sg": True, "Pl": True, "Invar": True}

    _inflection_tags = {"St": True, "Wk": True, "NoInfl": True, "Invar": True}

    _nonfinite_tags = {"Inf": True, "Part": True, "Invar": True}

    _function_tags = {
        "Attr": True,
        "Subst": True,
        "Attr/Subst": True,
        "Pred/Adv": True,
        "Cl": True,
        "NonCl": True,
        "Invar": True,
    }

    _mood_tags = {"Ind": True, "Subj": True, "Imp": True, "Invar": True}

    _tense_tags = {"Pres": True, "Past": True, "Perf": True, "Invar": True}

    _metainfo_tags = {"Old": True, "NonSt": True}

    _orthinfo_tags = {"OLDORTH": True, "CH": True}

    _ellipinfo_tags = {"TRUNC": True}

    _charinfo_tags = {"CAP": True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

    @cached_property
    def subcat(self):
        tag = self.tag_of_type(Analysis._subcat_tags)
        return tag

    @cached_property
    def auxiliary(self):
        tag = self.tag_of_type(Analysis._auxiliary_tags)
        return tag

    @cached_property
    def degree(self):
        tag = self.tag_of_type(Analysis._degree_tags)
        return tag

    @cached_property
    def person(self):
        tag = self.tag_of_type(Analysis._person_tags)
        return tag

    @cached_property
    def gender(self):
        tag = self.tag_of_type(Analysis._gender_tags)
        return tag

    @cached_property
    def case(self):
        tag = self.tag_of_type(Analysis._case_tags)
        return tag

    @cached_property
    def number(self):
        tag = self.tag_of_type(Analysis._number_tags)
        return tag

    @cached_property
    def inflection(self):
        tag = self.tag_of_type(Analysis._inflection_tags)
        return tag

    @cached_property
    def nonfinite(self):
        tag = self.tag_of_type(Analysis._nonfinite_tags)
        return tag

    @cached_property
    def function(self):
        tag = self.tag_of_type(Analysis._function_tags)
        return tag

    @cached_property
    def mood(self):
        tag = self.tag_of_type(Analysis._mood_tags)
        return tag

    @cached_property
    def tense(self):
        tag = self.tag_of_type(Analysis._tense_tags)
        return tag

    @cached_property
    def metainfo(self):
        tag = self.tag_of_type(Analysis._metainfo_tags)
        return tag

    @cached_property
    def orthinfo(self):
        tag = self.tag_of_type(Analysis._orthinfo_tags)
        return tag

    @cached_property
    def ellipinfo(self):
        tag = self.tag_of_type(Analysis._ellipinfo_tags)
        return tag

    @cached_property
    def charinfo(self):
        tag = self.tag_of_type(Analysis._charinfo_tags)
        return tag

    def as_dict(self):
        analysis = {
            "analysis": self.analysis,
            "lemma": self.lemma,
            "seg_lemma": self.seg_lemma,
            "lemma_index": self.lemma_index,
            "paradigm_index": self.paradigm_index,
            "process": self.process,
            "means": self.means,
            "pos": self.pos,
            "subcat": self.subcat,
            "auxiliary": self.auxiliary,
            "degree": self.degree,
            "person": self.person,
            "gender": self.gender,
            "case": self.case,
            "number": self.number,
            "inflection": self.inflection,
            "nonfinite": self.nonfinite,
            "function": self.function,
            "mood": self.mood,
            "tense": self.tense,
            "metainfo": self.metainfo,
            "orthinfo": self.orthinfo,
            "ellipinfo": self.ellipinfo,
            "charinfo": self.charinfo,
        }
        return analysis

    def _decode_component_text(text):
        lemma = ""
        text_len = len(text)
        ti = 0
        prev_char = None
        if text == r"\:":
            lemma = ":"
        else:
            while ti < text_len:
                current_char = text[ti]
                nti = ti + 1
                next_char = text[nti] if nti < text_len else None
                if current_char == ":":
                    lemma += prev_char or ""
                    ti += 1
                elif next_char != ":":
                    lemma += current_char
                    ti += 1
                    prev_char = current_char
        return {"lemma": lemma}

    def _decode_analysis(analyses):
        for analysis in re.finditer(r"([^<]*)(?:<([^>]*)>)?", analyses):
            text = analysis.group(1)
            tag = analysis.group(2) or ""
            component = Analysis._decode_component_text(text)
            if tag != "":
                component["tag"] = tag
            yield component

    def _join_tags(components):
        result = []
        current_component = None
        for component in components:
            component = component.copy()
            if current_component is None or component["lemma"] != "":
                component["tags"] = []
                result.append(component)
                current_component = component
            if "tag" in component:
                current_component["tags"].append(component["tag"])
                del component["tag"]
        return result

    def _join_untagged(components):
        result = []
        buf = []
        for component in components:
            buf.append(component)
            if len(component["tags"]) > 0:
                joined = {"lemma": "", "tags": []}
                for component in buf:
                    joined["lemma"] += component["lemma"]
                    joined["tags"] += component["tags"]
                if "+" in component["tags"]:
                    joined["lemma"] += " + "
                result.append(joined)
                buf = []
        if len(buf) > 0:
            result = result + buf
        return result


def parse(analyses):
    component_list = []
    for analysis in analyses:
        components = Analysis._decode_analysis(analysis)
        components = Analysis._join_tags(components)
        components = Analysis._join_untagged(components)
        if components not in component_list:
            component_list.append(components)
            yield Analysis(
                analysis, [Component(**component) for component in components]
            )


def analyse_word(transducer, word):
    return parse(transducer.analyse(word))


def analyse_words(transducer, words):
    return tuple(analyse_word(transducer, word) for word in words)


def generate_words(transducer, analysis):
    return tuple(transducer.generate(analysis))
