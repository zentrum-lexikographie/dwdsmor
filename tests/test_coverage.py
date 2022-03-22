import csv
import os

import dwdsmor


def test_tuebadz_coverage(tuebadz, dwdsmor_transducer):
    from collections import Counter
    print(Counter((
        w['pos'] for s in tuebadz for w in s
    )))
    for s in tuebadz[10:30]:
        for w in s:
            form, lemma, pos = (w['form'], w['lemma'], w['pos'])
            if pos.startswith('$'):
                continue
            if lemma == '#refl':
                lemma = form
            lemma = lemma.split('%')[0]
            lemma = lemma.replace('#', '')

            analyses = dwdsmor_transducer.analyse(form)
            analyses = dwdsmor.analysis.parse(analyses)

            print((form, lemma, pos, analyses))


def test_wb_coverage(project_dir, dwdsmor_transducer, wb_entries):
    coverage_report_file = project_dir / 'wb-coverage-report.csv'
    with coverage_report_file.open('w') as report_f:
        report_writer = csv.writer(report_f, lineterminator=os.linesep)
        report_writer.writerow([
            "Datei",
            "Status",
            "Lemma",
            "Wortklasse",
            "Flexionsinfo",
            "DWDSmor-Lemma",
            "DWDSmor-POS",
            "Abdeckung"
        ])
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
            report_writer.writerow([
                wb_entry['file'].as_posix(),
                wb_entry['article_status'],
                lemma,
                wb_entry['pos'],
                wb_entry['inflection_info'],
                analyzed_lemma,
                analyzed_pos,
                ("1" if analyzed else "0")
            ])
