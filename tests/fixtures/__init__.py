import random
import xml.etree.ElementTree as ET

from pathlib import Path
from pytest import fixture

import sfst_transduce


base_dir = (Path(__file__) / '..' / '..' / '..').resolve()
smor_lemma_dir = base_dir / 'SMORLemma'
tests_dir = base_dir / 'tests'


@fixture
def project_dir():
    return base_dir


@fixture
def dwdsmor_transducer():
    return sfst_transduce.CompactTransducer(
        (smor_lemma_dir / 'smor.ca').as_posix()
    )


@fixture
def men_women():
    return [
        'Frau', 'Frauen',
        'Mann', 'Männer', 'Mannes'
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


wb_dir = base_dir / 'lexicon' / 'wb'


def extract_wb_entries(wb_xml_file):
    entries = []
    with wb_xml_file.open() as f:
        wb_xml_doc = ET.parse(f).getroot()
        articles = wb_xml_doc.iter('{http://www.dwds.de/ns/1.0}Artikel')
        for article in articles:
            article_status = article.get('Status', '')
            if article_status != 'Red-f' and article_status != 'Red-2':
                continue
            forms = article.iter('{http://www.dwds.de/ns/1.0}Formangabe')
            for form in forms:
                pos = ''
                inflection_info = 1
                grammars = form.iter('{http://www.dwds.de/ns/1.0}Grammatik')
                for grammar in grammars:
                    pos_tags = grammar.iter(
                        '{http://www.dwds.de/ns/1.0}Wortklasse'
                    )
                    for pos_tag in pos_tags:
                        pos = pos_tag.text or ''
                        break
                    if pos == 'Substantiv':
                        if not (grammar.findall('{http://www.dwds.de/ns/1.0}Genitiv') or
                                grammar.findall('{http://www.dwds.de/ns/1.0}Plural')):
                            inflection_info = 0
                    if pos == 'Verb':
                        if not (grammar.findall('{http://www.dwds.de/ns/1.0}Praesens') or
                                grammar.findall('{http://www.dwds.de/ns/1.0}Praeteritum')):
                            inflection_info = 0
                    break
                if pos == 'Mehrwortausdruck':
                    continue
                written_reprs = form.iter(
                    '{http://www.dwds.de/ns/1.0}Schreibung'
                )
                for written_repr in written_reprs:
                    if written_repr.get('Typ', '').startswith('U'):
                        continue
                    entries.append({
                        'file': wb_xml_file.relative_to(wb_dir),
                        'article_status': article_status,
                        'pos': pos,
                        'inflection_info': inflection_info,
                        'written_repr': " ".join((written_repr.text or '').split())
                    })
    return entries


@fixture
def wb_entries():
    if not wb_dir.is_dir():
        return []
    return (
        wb_entry
        for wb_xml_file in wb_dir.glob('**/*.xml')
        for wb_entry in extract_wb_entries(wb_xml_file)
    )
