from collections import namedtuple, defaultdict
import csv
import os

import dwdsmor
import dwdsmor.analysis


def write_csv_report(csv_report_file, csv_header, csv_rows):
    csv_report_file.parent.mkdir(parents=True, exist_ok=True)
    with csv_report_file.open('w') as report_f:
        report_writer = csv.writer(report_f, lineterminator=os.linesep)
        report_writer.writerow(csv_header)
        for csv_row in csv_rows:
            report_writer.writerow(csv_row)


LemmatizedWord = namedtuple(
    'LemmatizedWord', ('form', 'lemma', 'pos', 'dwdsmor_lemma', 'is_match')
)


def lemmatize(dwdsmor_transducer, w):
    form, lemma, pos = (w.get('form', ''), w.get('lemma', ''), w.get('pos', ''))
    dwdsmor_lemma = ''
    if not pos.startswith('$'):
        if lemma == '#refl':
            lemma = form
        lemma = lemma.split('%')[0]
        lemma = lemma.replace('#', '')

        analyses = dwdsmor_transducer.analyse(form)
        analyses = tuple(dwdsmor.analysis.parse(analyses))
        analyses = tuple(a for a in analyses if pos.startswith(a.pos)) +\
            analyses
        if len(analyses) > 0:
            dwdsmor_lemma = analyses[0].lemma

    return LemmatizedWord(
        form, lemma, pos, dwdsmor_lemma, lemma == dwdsmor_lemma
    )


def test_tuebadz_coverage(project_dir, tuebadz, dwdsmor_transducer):
    lemmatized = (lemmatize(dwdsmor_transducer, w) for s in tuebadz for w in s)
    stats = defaultdict(lambda: defaultdict(int))
    for w in lemmatized:
        stats[w.pos][w.is_match] += 1
    write_csv_report(
        project_dir / 'test-reports' / 'tuebadz-coverage.csv',
        ('Wortklasse', 'Matches', 'Mismatches'),
        ((pos, str(matches[True]), str(matches[False]))
         for pos, matches in (sorted(stats.items())))
    )


def wb_coverage(dwdsmor_transducer, wb_entries):
    for wb_n, wb_entry in enumerate(wb_entries):
        lemma = wb_entry['written_repr']
        analyses = dwdsmor_transducer.analyse(lemma)
        analyses = dwdsmor.analysis.parse(analyses)
        analyzed = False
        analyzed_lemma = ''
        analyzed_pos = ''
        for analysis in analyses:
            if analysis.lemma == lemma:
                analyzed = True
                analyzed_lemma = analysis.lemma or ''
                analyzed_pos = analysis.pos or ''
                break
        yield (
            wb_entry['file'].as_posix(),
            wb_entry['article_status'],
            lemma,
            wb_entry['pos'],
            wb_entry['inflection_info'],
            analyzed_lemma,
            analyzed_pos,
            ("1" if analyzed else "0")
        )


def test_wb_coverage(project_dir, dwdsmor_transducer, wb_entries):
    write_csv_report(
        project_dir / 'test-reports' / 'wb-coverage.csv',
        ('Datei', 'Status', 'Lemma', 'Wortklasse', 'Flexionsinfo',
         'DWDSmor-Lemma', 'DWDSmor-POS', 'Abdeckung'),
        wb_coverage(dwdsmor_transducer, wb_entries)
    )
