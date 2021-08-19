import xml.etree.ElementTree as ET

from .xml import dwds_qn, text

class_mapping = {
    # Gender
    'mask.': {
        # Genitive
        '-(e)s': {
            # Plural
            '-er': {
                # Umlaut
                True: 'NMasc_es_$er'
            }
        }
    },
    'fem.': {
        '-': {
            '-en': {
                False: 'NFem_0_en'
            }
        }
    },
    'neutr.': {
        '-(e)s': {
            '-er': {
                False: 'NNeut_es_er'
            }
        }
    }
}


umlaut_trans = str.maketrans('ÄÖÜäöü', 'AOUaou')


def noun_to_lexicon_articles(article):
    for surface_form in article.iter(dwds_qn('Formangabe')):
        lemma = text(surface_form.find(dwds_qn('Schreibung')))
        if lemma is None:
            continue
        if '-' in lemma:
            continue
        for grammar in surface_form.iter(dwds_qn('Grammatik')):
            pos = text(grammar.find(dwds_qn('Wortklasse')))
            if pos is None:
                continue
            gender = text(grammar.find(dwds_qn('Genus')))
            genitive = text(grammar.find(dwds_qn('Genitiv')))
            plural = text(grammar.find(dwds_qn('Plural')))
            if not all([gender, genitive, plural]):
                continue
            umlaut = not plural.startswith('-')
            if umlaut:
                plural = '-' + plural.translate(umlaut_trans)[len(lemma):]
            inflection_class = class_mapping
            for k in [gender, genitive, plural, umlaut]:
                inflection_class = inflection_class.get(k)
                if inflection_class is None:
                    break
            if inflection_class is None:
                continue
            entry = ET.Element('BaseStem')
            ET.SubElement(entry, 'Lemma').text = lemma
            ET.SubElement(entry, 'Stem').text = lemma
            ET.SubElement(entry, 'Pos').text = 'NN'
            ET.SubElement(entry, 'Origin').text = 'nativ'
            ET.SubElement(entry, 'InfClass').text = inflection_class
            yield entry
