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


tuebadz_dwdsmor_map = {
    "ADJA": {
        "ander": "andere",
        "besser": "gut",
        "best": "gut",
        "größt": "groß",
        "länger": "lang",
        "längst": "lang",
        "nächst": "nahe",
        "näher": "nahe"
    },
    "ADJD": {
        "besser": "gut",
        "best": "gut",
        "länger": "lang",
        "längst": "lang",
        "später": "spät"
    },
    "ADV": {
        "eher": "bald",
        "lieber": "gerne",
        "mehr": "sehr",
        "öfter": "oft",
        "weiter": "weit",
        "weniger": "wenig"
    },
    "ART": {
        "das": "die",
        "der": "die",
        "der|die|das": "die",
        "ein": "eine",
        "ein|eine": "eine"
    },
    "NN": {
        "Abgeordneter": "Abgeordnete",
        "Abgeordneter|Abgeordnete|Abgeordnetes": "Abgeordnete",
        "Abhängiger": "Abhängige",
        "Abhängiger|Abhängige|Abhängiges": "Abhängige",
        "Alliierter": "Alliierte",
        "Alliierter|Alliierte|Alliiertes": "Alliierte",
        "Alter": "Alte",
        "Alter|Alte|Altes": "Alte",
        "Älterer": "Ältere",
        "Älterer|Ältere|Älteres": "Ältere",
        "Angehöriger": "Angehörige",
        "Angehöriger|Angehörige|Angehöriges": "Angehörige",
        "Angeklagter": "Angeklagte",
        "Angeklagter|Angeklagte|Angeklagtes": "Angeklagte",
        "Angestellter": "Angestellte",
        "Angestellter|Angestellte|Angestelltes": "Angestellte",
        "Aufständischer": "Aufständische",
        "Aufständischer|Aufständische|Aufständisches": "Aufständische",
        "Autonomer": "Autonome",
        "Autonomer|Autonome|Autonomes": "Autonome",
        "Beamter": "Beamte",
        "Bediensteter": "Bedienstete",
        "Bediensteter|Bedienstete|Bedienstetes": "Bedienstete",
        "Befragter": "Befragte",
        "Befragter|Befragte|Befragtes": "Befragte",
        "Behinderter": "Behinderte",
        "Behinderter|Behinderte|Behindertes": "Behinderte",
        "Bekannter": "Bekannte",
        "Bekannter|Bekannte|Bekanntes": "Bekannte",
        "Beschäftigter": "Beschäftigte",
        "Beschäftigter|Beschäftigte|Beschäftigtes": "Beschäftigte",
        "Beschuldigter": "Beschuldigte",
        "Beschuldigter|Beschuldigte|Beschuldigtes": "Beschuldigte",
        "Bester": "Beste",
        "Bestes": "Beste",
        "Bester|Beste|Bestes": "Beste",
        "Beteiligter": "Beteiligte",
        "Beteiligter|Beteiligte|Beteiligtes": "Beteiligte",
        "Betroffener": "Betroffene",
        "Betroffener|Betroffene|Betroffenes": "Betroffene",
        "Blinder": "Blinde",
        "Blinder|Blinde|Blindes": "Blinde",
        "Bundestagsabgeordneter": "Bundestagsabgeordnete",
        "Bundestagsabgeordneter|Bundestagsabgeordnete|Bundestagsabgeordnetes": "Bundestagsabgeordnete",
        "Bündnisgrüner": "Bündnisgrüne",
        "Bündnisgrüner|Bündnisgrüne|Bündnisgrünes": "Bündnisgrüne",
        "Delegierter": "Deligierte",
        "Delegierter|Delegierte|Delegiertes": "Deligierte",
        "Deutscher": "Deutsche",
        "Deutsches": "Deutsche",
        "Deutscher|Deutsche|Deutsches": "Deutsche",
        "Dritter": "Dritte",
        "Drittes": "Dritte",
        "Dritter|Dritte|Drittes": "Dritte",
        "Drogenabhängiger": "Drogenabhängige",
        "Drogenabhängiger|Drogenabhängige|Drogenabhängiges": "Drogenabhängige",
        "Drogensüchtiger": "Drogensüchtige",
        "Drogensüchtiger|Drogensüchtige|Drogensüchtiges": "Drogensüchtige",
        "Eingeborener": "Eingeborene",
        "Eingeborener|Eingeborene|Eingeborenes": "Eingeborene",
        "Einheimischer": "Einheimische",
        "Einheimischer|Einheimische|Einheimisches": "Einheimische",
        "Erster": "Erste",
        "Erstes": "Erste",
        "Erster|Erste|Erstes": "Erste",
        "Erwachsener": "Erwachsene",
        "Erwachsener|Erwachsene|Erwachsenes": "Erwachsene",
        "Familienangehöriger": "Familienangehörige",
        "Familienangehöriger|Familienangehörige|Familienangehöriges": "Familienangehörige",
        "Fraktionsvorsitzender": "Fraktionsvorsitzende",
        "Fraktionsvorsitzender|Fraktionsvorsitzende|Fraktionsvorsitzendes": "Fraktionsvorsitzende",
        "Freies": "Freie",
        "Freier|Freie|Freies": "Freie",
        "Freiwilliger": "Freiwillige",
        "Freiwilliger|Freiwillige|Freiwilliges": "Freiwillige",
        "Fremder": "Fremde",
        "Fremder|Fremde|Fremdes": "Fremde",
        "Ganzes": "Ganze",
        "Ganzer|Ganze|Ganzes": "Ganze",
        "Gefangener": "Gefangene",
        "Gefangener|Gefangene|Gefangenes": "Gefangene",
        "Gläubiger": "Gläubige",
        "Gläubiger|Gläubige|Gläubiges": "Gläubige",
        "Gleicher": "Gleiche",
        "Gleiches": "Gleiche",
        "Gleicher|Gleiche|Gleiches": "Gleiche",
        "Geschworener": "Geschworene",
        "Geschworener|Geschworene|Geschworenes": "Geschworene",
        "Grüner": "Grüne",
        "Grüner|Grüne|Grünes": "Grüne",
        "Herrschender": "Herrschende",
        "Herrschender|Herrschende|Herrschendes": "Herrschende",
        "Heterosexueller": "Heterosexuelle",
        "Heterosexueller|Heterosexuelle|Heterosexuelles": "Heterosexuelle",
        "Hinterbliebener": "Hinterbliebene",
        "Hinterbliebener|Hinterbliebene|Hinterbliebenes": "Hinterbliebene",
        "Homosexueller": "Homosexuelle",
        "Homosexueller|Homosexuelle|Homosexuelles": "Homosexuelle",
        "Inhaftierter": "Inhaftierte",
        "Inhaftierter|Inhaftierte|Inhaftiertes": "Inhaftierte",
        "Innerer": "Innere",
        "Inneres": "Innere",
        "Innerer|Innere|Inneres": "Innere",
        "Intellektueller": "Intellektuelle",
        "Intellektueller|Intellektuelle|Intellektuelles": "Intellektuelle",
        "Jugendlicher": "Jugendliche",
        "Jugendlicher|Jugendliche|Jugendliches": "Jugendliche",
        "Junger": "Junge",
        "Junger|Junge|Junges": "Junge",
        "Jüngerer": "Jüngere",
        "Jüngerer|Jüngere|Jüngeres": "Jüngere",
        "Kranker": "Kranke",
        "Kranker|Kranke|Krankes": "Kranke",
        "Kreisvorsitzender": "Kreisvorsitzende",
        "Kreisvorsitzender|Kreisvorsitzende|Kreisvorsitzendes": "Kreisvorsitzende",
        "Krimineller": "Kriminelle",
        "Krimineller|Kriminelle|Kriminelles": "Kriminelle",
        "Konservativer": "Konservative",
        "Konservativer|Konservative|Konservatives": "Konservative",
        "Kulturschaffender": "Kulturschaffende",
        "Kulturschaffender|Kulturschaffende|Kulturschaffendes": "Kulturschaffende",
        "Landesvorsitzender": "Landesvorsitzende",
        "Landesvorsitzender|Landesvorsitzende|Landesvorsitzendes": "Landesvorsitzende",
        "Lebender|Lebende|Lebendes": "Lebende",
        "Lehrender": "Lehrende",
        "Lehrender|Lehrende|Lehrendes": "Lehrende",
        "Liberaler": "Liberale",
        "Liberaler|Liberale|Liberales": "Liberale",
        "Linker": "Linke",
        "Linker|Linke|Linkes": "Linke",
        "Mächtiger": "Mächtige",
        "Mächtiger|Mächtige|Mächtiges": "Mächtige",
        "Minderjähriger": "Minderjährige",
        "Minderjähriger|Minderjährige|Minderjähriges": "Minderjährige",
        "Offizieller": "Offizielle",
        "Offizieller|Offizielle|Offizielles": "Offizielle",
        "Oppositioneller": "Oppositionelle",
        "Oppositioneller|Oppositionelle|Oppositionelles": "Oppositionelle",
        "Orthodoxer": "Orthodoxe",
        "Orthodoxer|Orthodoxe|Orthodoxes": "Orthodoxe",
        "Ostdeutscher": "Ostdeutsche",
        "Ostdeutscher|Ostdeutsche|Ostdeutsches": "Ostdeutsche",
        "Parteivorsitzender": "Parteivorsitzende",
        "Parteivorsitzender|Parteivorsitzende|Parteivorsitzendes": "Parteivorsitzende",
        "Polizeibeamter": "Polizeibeamte",
        "Prominenter": "Prominente",
        "Prominenter|Prominente|Prominentes": "Prominente",
        "Prostituierter": "Prostituierte",
        "Prostituierter|Prostituierte|Prostituiertes": "Prostituierte",
        "Protestierender": "Protestierende",
        "Protestierender|Protestierende|Protestierendes": "Protestierende",
        "Regierender": "Regierende",
        "Regierender|Regierende|Regierendes": "Regierende",
        "Reisender": "Reisende",
        "Reisender|Reisende|Reisendes": "Reisende",
        "Sachverständiger": "Sachverständige",
        "Sachverständiger|Sachverständige|Sachverständiges": "Sachverständige",
        "Schwarzer": "Schwarze",
        "Schwarzes": "Schwarze",
        "Schwarzer|Schwarze|Schwarzes": "Schwarze",
        "Schwuler": "Schwule",
        "Schwuler|Schwule|Schwules": "Schwule",
        "Sozialer": "Soziale",
        "Soziales": "Soziale",
        "Sozialer|Soziale|Soziales": "Soziale",
        "Standesbeamter": "Standesbeamte",
        "Streikender": "Streikende",
        "Streikender|Streikende|Streikendes": "Streikende",
        "Studierender": "Studierende",
        "Studierender|Studierende|Studierendes": "Studierende",
        "Süchtiger|Süchtige|Süchtiges": "Süchtige",
        "Toter": "Tote",
        "Toter|Tote|Totes": "Tote",
        "Überlebender": "Überlegende",
        "Überlebender|Überlebende|Überlebendes": "Überlegende",
        "Unbekannter": "Unbekannte",
        "Unbekannter|Unbekannte|Unbekanntes": "Unbekannte",
        "Verantwortlicher": "Verantwortliche",
        "Verantwortlicher|Verantwortliche|Verantwortliches": "Verantwortliche",
        "Verbündeter": "Verbündete",
        "Verbündeter|Verbündete|Verbündetes": "Verbündete",
        "Verdächtiger": "Verdächtige",
        "Verdächtiger|Verdächtige|Verdächtiges": "Verdächtige",
        "Verfolgter": "Verfolgte",
        "Verfolgter|Verfolgte|Verfolgtes": "Verfolgte",
        "Verletzter": "Verletzte",
        "Verletzter|Verletzte|Verletztes": "Verletzte",
        "Vertriebener": "Vertriebene",
        "Vertriebener|Vertriebene|Vertriebenes": "Vertriebene",
        "Verurteilter": "Verurteilte",
        "Verurteilter|Verurteilte|Verurteiltes": "Verurteilte",
        "Verwandter": "Verwandte",
        "Verwandter|Verwandte|Verwandtes": "Verwandte",
        "Vorgesetzter": "Vorgesetzte",
        "Vorgesetzter|Vorgesetzte|Vorgesetztes": "Vorgesetzte",
        "Vorsitzender": "Vorsitzende",
        "Vorsitzender|Vorsitzende|Vorsitzendes": "Vorsitzende",
        "Vorstandsvorsitzender": "Vorstandsvorsitzende",
        "Vorstandsvorsitzender|Vorstandsvorsitzende|Vorstandsvorsitzendes": "Vorstandsvorsitzende",
        "Wahlberechtigter": "Wahlberechtigte",
        "Wahlberechtigter|Wahlberechtigte|Wahlberechtigtes": "Wahlberechtigte",
        "Weißer": "Weiße",
        "Weißer|Weiße|Weißes": "Weiße",
        "Zweiter": "Zweite",
        "Zweites": "Zweite",
        "Zweiter|Zweite|Zweites": "Zweite"
    },
    "PDAT": {
        "alles": "alle",
        "dasjenige": "diejenige",
        "das": "die",
        "der": "die",
        "der|die|das": "die",
        "deren": "die",
        "derjenige": "diejenige",
        "derjenige|diejenige|dasjenige": "diejenige",
        "dessen": "die",
        "dessen|deren": "die",
        "dieser": "diese",
        "dieser|diese|dieses": "diese",
        "dieses": "diese"
    },
    "PDS": {
        "dasjenige": "diejenige",
        "derjenige": "diejenige",
        "das": "die",
        "der": "die",
        "der|die|das": "die",
        "derjenige|diejenige|dasjenige": "diejenige",
        "dieser": "diese",
        "dieser|diese|dieses": "diese",
        "dieses": "diese"
    },
    "PIAT": {
        "kein": "keine",
        "keiner": "keine",
        "kein|keine": "keine",
        "keines": "keine",
        "mehr": "viel"
    },
    "PIDAT": {
        "alles": "alle",
        "jeder": "jede",
        "jedes": "jede"
    },
    "PIS": {
        "alles": "alle",
        "anderer": "andere",
        "anderer|andere|anderes": "andere",
        "anderes": "andere",
        "jeder": "jede",
        "jeder|jede|jedes": "jede",
        "jedes": "jede",
        "keiner": "keine",
        "keiner|keine|keines": "keine",
        "keines": "keine",
        "mehr": "viel"
    },
    "PPER": {
        "du": "sie",
        "er": "sie",
        "er|sie|es": "sie",
        "es": "sie",
        "ich": "sie",
        "ihr": "sie",
        "wir": "sie",
        "Sie": "sie"
    },
    "PPOSAT": {
        "dein": "deine",
        "dein|deine": "deine",
        "euer": "eure",
        "euer|eure": "eure",
        "ihr": "ihre",
        "ihr|ihre": "ihre",
        "mein": "meine",
        "mein|meine": "meine",
        "sein": "seine",
        "sein|seine": "seine",
        "unser": "unsre",
        "unser|unsere": "unsre",
        "unsere": "unsre"
    },
    "PRELAT": {
        "deren": "die",
        "dessen": "die",
        "dessen|deren": "die"
    },
    "PRELS": {
        "das": "die",
        "der": "die",
        "der|die|das": "die"
    },
    "PRF": {
        "dich": "sie",
        "dir": "sie",
        "euch": "sie",
        "mich": "sie",
        "mir": "sie",
        "sich": "sie",
        "uns": "sie"
    }
}


def tuebadz_to_dwdsmor(pos, lemma):
    if pos in tuebadz_dwdsmor_map and lemma in tuebadz_dwdsmor_map[pos]:
        return tuebadz_dwdsmor_map[pos][lemma]
    else:
        return lemma


LemmatizedWord = namedtuple(
    'LemmatizedWord', ('form', 'lemma', 'pos', 'dwdsmor_lemma', 'is_match')
)


def lemmatize(dwdsmor_transducer, w):
    form, lemma, pos = (w.get('form', ''), w.get('lemma', ''), w.get('pos', ''))
    dwdsmor_lemma = ''
    if not pos.startswith('$'):
        if pos == 'PTKVZ' or lemma == '#refl':
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
        form, lemma, pos, dwdsmor_lemma, tuebadz_to_dwdsmor(pos, lemma) == dwdsmor_lemma
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


def test_tuebadz_lemmatisation(project_dir, tuebadz, dwdsmor_transducer):
    lemmatized = (lemmatize(dwdsmor_transducer, w) for s in tuebadz for w in s)
    write_csv_report(
        project_dir / 'test-reports' / 'tuebadz-lemmatisation.csv',
        ('Wortklasse', 'Form', 'Lemma', 'DWDSmor-Lemma', 'Lemma-Match'),
        ((w.pos, w.form, w.lemma, w.dwdsmor_lemma, w.is_match)
         for w in lemmatized)
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
