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
def lexicon():
    with (smor_lemma_dir / 'lexicon' / 'wiki-lexicon.xml').open() as f:
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
def lexicon_sample(lexicon):
    sample_size = 100
    if len(lexicon) <= sample_size:
        return lexicon
    else:
        return random.sample(lexicon, sample_size)
