import csv
import os

import dwdsmor


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
