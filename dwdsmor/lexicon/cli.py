import itertools
from pathlib import Path
import xml.etree.ElementTree as ET

import click

from .nouns import noun_to_lexicon_articles
from .xml import dwds_qn, text


def article_files(wb_dirs):
    for d in (wb_dirs or []):
        d = Path(d)
        for f in d.glob('**/*.xml'):
            yield (f, f.relative_to(d).as_posix())


def article_to_lexicon_entries(article_file):
    article_xml = ET.parse(article_file.as_posix())
    for article in article_xml.iter(dwds_qn('Artikel')):
        for surface_form in article.iter(dwds_qn('Formangabe')):
            for grammar in surface_form.iter(dwds_qn('Grammatik')):
                pos = text(grammar.find(dwds_qn('Wortklasse')))
                if pos == 'Substantiv':
                    for entry in noun_to_lexicon_articles(article):
                        yield entry


def lexicon_entries(wb_dirs):
    for f, p in article_files(wb_dirs):
        for lexicon_entry in article_to_lexicon_entries(f):
            yield lexicon_entry


@click.command()
@click.argument(
    'wb_dirs',
    nargs=-1,
    type=click.Path(exists=True, file_okay=False, resolve_path=True)
)
@click.argument(
    'output',
    nargs=1,
    type=click.File('wb')
)
def main(wb_dirs, output):
    lexicon = ET.Element('smor')
    for entry in itertools.islice(lexicon_entries(wb_dirs), 0, 1000):
        lexicon.append(entry)
    ET.ElementTree(lexicon).write(output, encoding='UTF-8')


if __name__ == '__main__':
    main()
