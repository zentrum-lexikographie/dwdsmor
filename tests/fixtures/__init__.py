import random
import xml.etree.ElementTree as ET

from pathlib import Path
from pytest import fixture

import sfst


base_dir = (Path(__file__) / '..' / '..' / '..').resolve()
smor_lemma_dir = base_dir / 'SMORLemma'
tests_dir = base_dir / 'tests'


@fixture
def smor_lemma():
    return sfst.CompactTransducer((smor_lemma_dir / 'smor.ca').as_posix())


@fixture
def men_women():
    return [
        'Mann', 'Männer', 'Mannes', 'Männchen',
        'Frau', 'Frauen', 'Fräulein'
    ]


@fixture
def irregular_nouns():
    with (smor_lemma_dir / 'lexicon' / 'nouns.irreg.xml').open() as f:
        lexicon_xml = ET.parse(f)
        return list([
            {'lemma': entry.find('Lemma').text,
             'stem': entry.find('Stem').text,
             'pos': entry.find('Pos').text,
             'origin': entry.find('Origin').text,
             'inflection_class': entry.find('InfClass').text}
            for entry in lexicon_xml.iter('BaseStem')
        ])


@fixture
def lexicon_sample(irregular_nouns):
    sample_size = 100
    if len(irregular_nouns) <= sample_size:
        return irregular_nouns
    else:
        return random.sample(irregular_nouns, sample_size)
