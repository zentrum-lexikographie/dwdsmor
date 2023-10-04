# tests/Makefile
# Andreas Nolda 2023-10-04

PYTEST = py.test --no-header

PYTEST_RUN    = $(PYTEST) -v -v
PYTEST_UPDATE = $(PYTEST) -W ignore --snapshot-update

TESTDIR   = $(CURDIR)
REPORTDIR = $(TESTDIR)/reports

TESTDWDSLEMMAS      = $(TESTDIR)/test_dwds_lemmas.py
TESTSAMPLELEMMAS    = $(TESTDIR)/test_sample_lemmas.py
TESTTUEBADZLEMMAS   = $(TESTDIR)/test_tuebadz_lemmas.py
TESTTUEBADZCOVERAGE = $(TESTDIR)/test_tuebadz_coverage.py
TESTPARADIGMS       = $(TESTDIR)/test_paradigms.py

REPORTDWDSLEMMAS      = $(REPORTDIR)/dwds-lemmas.tsv
REPORTSAMPLELEMMAS    = $(REPORTDIR)/sample-lemmas.tsv
REPORTTUEBADZLEMMAS   = $(REPORTDIR)/tuebadz-lemmas.tsv
REPORTTUEBADZCOVERAGE = $(REPORTDIR)/tuebadz-coverage.tsv
REPORTPARADIGMS       = $(REPORTDIR)/adjective-paradigms.tsv \
                        $(REPORTDIR)/article-paradigms.tsv \
                        $(REPORTDIR)/cardinal-paradigms.tsv \
                        $(REPORTDIR)/demonstrative-pronoun-paradigms.tsv \
                        $(REPORTDIR)/indefinite-pronoun-paradigms.tsv \
                        $(REPORTDIR)/interrogative-pronoun-paradigms.tsv \
                        $(REPORTDIR)/name-paradigms.tsv \
                        $(REPORTDIR)/noun-paradigms.tsv \
                        $(REPORTDIR)/ordinal-paradigms.tsv \
                        $(REPORTDIR)/personal-pronoun-paradigms.tsv \
                        $(REPORTDIR)/possessive-pronoun-paradigms.tsv \
                        $(REPORTDIR)/relative-pronoun-paradigms.tsv \
                        $(REPORTDIR)/verb-paradigms.tsv

REPORTFILES = $(REPORTDWDSLEMMAS) \
              $(REPORTSAMPLELEMMAS) \
              $(REPORTTUEBADZLEMMAS) \
              $(REPORTTUEBADZCOVERAGE) \
              $(REPORTPARADIGMS)

all: test-dwds-lemmas test-sample-lemmas \
     test-tuebadz-lemmas test-tuebadz-coverage \
     test-paradigms

test-dwds-lemmas: $(REPORTDWDSLEMMAS)

test-sample-lemmas: $(REPORTSAMPLELEMMAS)

test-tuebadz-lemmas: $(REPORTTUEBADZLEMMAS)

test-tuebadz-lemmas: $(REPORTTUEBADZLEMMAS)

test-tuebadz-coverage: $(REPORTTUEBADZCOVERAGE)

test-paradigms: $(REPORTPARADIGMS)

test-paradigms-regression:
	$(PYTEST_RUN) $(TESTPARADIGMS)

$(REPORTDWDSLEMMAS): $(TESTDWDSLEMMAS)
	$(PYTEST_RUN) $(TESTDWDSLEMMAS)

$(REPORTSAMPLELEMMAS): $(TESTSAMPLELEMMAS)
	$(PYTEST_RUN) $(TESTSAMPLELEMMAS)

$(REPORTTUEBADZLEMMAS): $(TESTTUEBADZLEMMAS)
	$(PYTEST_RUN) $(TESTTUEBADZLEMMAS)

$(REPORTTUEBADZCOVERAGE): $(TESTTUEBADZCOVERAGE)
	$(PYTEST_RUN) $(TESTTUEBADZCOVERAGE)

$(REPORTPARADIGMS) &: $(TESTPARADIGMS)
	$(PYTEST_UPDATE) $(TESTPARADIGMS)

clean:
	$(RM) $(REPORTFILES)

.PHONY: all \
        test-dwds-lemmas test-sample-lemmas \
        test-tuebadz-lemmas test-tuebadz-coverage \
        test-paradigms test-paradigms-regression \
        clean
