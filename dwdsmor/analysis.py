from collections import namedtuple
from functools import cached_property

import csv
import json
import re

import click
import jellyfish

import sfst

Morpheme = namedtuple('Morpheme', ['word', 'lemma', 'tags'])


class Analysis(tuple):
    def __new__(cls, analysis, morphemes):
        inst = tuple.__new__(cls, morphemes)
        inst.analysis = analysis
        return inst

    @cached_property
    def word(self):
        return ''.join(m.word for m in self)

    @cached_property
    def lemma(self):
        return ''.join(m.lemma for m in self)

    @cached_property
    def tags(self):
        return [tag for m in self for tag in m.tags]

    @cached_property
    def pos(self):
        for tag in self.tags:
            if tag.startswith('+'):
                return tag[1:]

    _genus_tags = {'Fem': True, 'Neut': True, 'Masc': True}
    _numerus_tags = {'Sg': True, 'Pl': True}
    _person_tags = {'1': True, '2': True, '3': True}
    _casus_tags = {'Nom': True, 'Gen': True, 'Dat': True, 'Acc': True}
    _tempus_tags = {'Pres': True, 'Past': True, 'PPast': True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

    @cached_property
    def genus(self):
        return self.tag_of_type(Analysis._genus_tags)

    @cached_property
    def numerus(self):
        return self.tag_of_type(Analysis._numerus_tags)

    @cached_property
    def person(self):
        return self.tag_of_type(Analysis._person_tags)

    @cached_property
    def casus(self):
        return self.tag_of_type(Analysis._casus_tags)

    @cached_property
    def tempus(self):
        return self.tag_of_type(Analysis._tempus_tags)

    @cached_property
    def dist_score(self):
        return jellyfish.levenshtein_distance(
            self.word.lower(), self.lemma.lower()
        )

    def as_dict(self):
        return {
            'word': self.word,
            'analysis': self.analysis,
            'lemma': self.lemma,
            'pos': self.pos,
            'genus': self.genus,
            'numerus': self.numerus,
            'casus': self.casus,
            'person': self.person,
            'tempus': self.tempus,
            'morphemes': [m._asdict() for m in self]
        }

    _empty_component_texts = set(['', ':'])
    _curly_braces_re = re.compile(r'[{}]')

    def _decode_component_text(text):
        lemma = ''
        word = ''
        text_len = len(text)
        ti = 0
        prev = None
        while ti < text_len:
            current = text[ti]
            nti = ti + 1
            next = text[nti] if nti < text_len else None
            if current == ':':
                lemma += prev or ''
                word += next or ''
                ti += 1
            elif next != ':':
                lemma += current
                word += current
            ti += 1
            prev = current
        return {'lemma': lemma, 'word': word}

    def _decode_analysis(analysis):
        # 'QR-Code' -> '{:<>QR}:<>-<TRUNC>:<>Code<+NN>:<><Masc>:<><Acc>:<><Sg>:<>'
        analysis = Analysis._curly_braces_re.sub('', analysis)

        for m in re.finditer(r'([^<]*)(?:<([^>]*)>)?', analysis):
            text = m.group(1)
            tag = m.group(2) or ''
            component = Analysis._decode_component_text(text)
            if tag != '':
                component['tag'] = tag
            yield component

    def _join_tags(analysis):
        result = []
        current = None
        for c in analysis:
            c = c.copy()
            if current is None or c['word'] != '' or c['lemma'] != '':
                c['tags'] = []
                result.append(c)
                current = c
            if 'tag' in c:
                current['tags'].append(c['tag'])
                del c['tag']
        return result

    def _join_untagged(analysis):
        result = []
        buf = []
        for c in analysis:
            buf.append(c)
            if len(c['tags']) > 0:
                joined = {'lemma': '', 'word': '', 'tags': []}
                for c in buf:
                    joined['lemma'] += c['lemma']
                    joined['word'] += c['word']
                    joined['tags'] += c['tags']
                result.append(joined)
                buf = []
        if len(buf) > 0:
            result = result + buf
        return result


def parse(analyses):
    for analysis in analyses:
        morphemes = Analysis._decode_analysis(analysis)
        morphemes = Analysis._join_tags(morphemes)
        morphemes = Analysis._join_untagged(morphemes)
        yield Analysis(analysis, [Morpheme(**m) for m in morphemes])


def create_transducer(file_name):
    try:
        smor = sfst.CompactTransducer(file_name)
        smor.both_layers = True
        return smor
    except RuntimeError:
        raise click.ClickException(
            f'Cannot instantiate transducer from {file_name}'
        )


@click.command()
@click.option(
    '-a', '--automaton',
    required=True,
    type=click.Path(exists=True, dir_okay=False),
    help='Path to the FST (compacted, i.e. *.ca)'
)
@click.option(
    '--csv', 'output_format',
    flag_value='csv',
    default=True,
    help='Output in CSV format (default)'
)
@click.option(
    '--json', 'output_format',
    flag_value='json',
    help='Output in JSON format'
)
@click.argument(
    'input',
    type=click.File('r'),
    default='-'
)
@click.argument(
    'output',
    type=click.File('w'),
    default='-'
)
def main(automaton, output_format, input, output):
    '''DWDSmor Morphological Analysis

    Copyright (C) 2021 Berlin-Brandenburgische Akademie der Wissenschaften

    Feeds word forms – given as one form per line – into a finite state
    transducer and outputs the results – valid paths through the transducer
    representing possible analyses.

    INPUT is the file with word forms to analyze (defaults to stdin).

    OUTPUT is the file to write results to (defaults to stdout).'''
    smor = create_transducer(click.format_filename(automaton))
    words = tuple(map(lambda l: l.strip(), input.readlines()))
    analyses = tuple([parse(smor.analyse(word)) for word in words])
    if output_format == 'json':
        json.dump({
            word: [a.as_dict() for a in analysis]
            for word, analysis in zip(words, analyses)
        }, output)
    elif output_format == 'csv':
        csv_writer = csv.writer(output)
        csv_writer.writerow([
            "Word", "Analysis", "Lemma", "POS",
            "Gender", "Number", "Case", "Person", "Tense"
        ])
        for word, analysis in zip(words, analyses):
            for a in analysis:
                csv_writer.writerow([
                    word, a.analysis, a.lemma, a.pos,
                    a.genus, a.numerus, a.casus, a.person, a.tempus
                ])


if __name__ == '__main__':
    main()
