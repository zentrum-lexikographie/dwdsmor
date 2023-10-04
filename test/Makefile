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

REPORTDWDSLEMMAS      = $(REPORTDIR)/dwds-lemmas.tsv
REPORTSAMPLELEMMAS    = $(REPORTDIR)/sample-lemmas.tsv
REPORTTUEBADZLEMMAS   = $(REPORTDIR)/tuebadz-lemmas.tsv
REPORTTUEBADZCOVERAGE = $(REPORTDIR)/tuebadz-coverage.tsv

REPORTFILES = $(REPORTDWDSLEMMAS) \
              $(REPORTSAMPLELEMMAS) \
              $(REPORTTUEBADZLEMMAS) \
              $(REPORTTUEBADZCOVERAGE)

all: test-dwds-lemmas test-sample-lemmas \
     test-tuebadz-lemmas test-tuebadz-coverage

test-dwds-lemmas: $(REPORTDWDSLEMMAS)

test-sample-lemmas: $(REPORTSAMPLELEMMAS)

test-tuebadz-lemmas: $(REPORTTUEBADZLEMMAS)

test-tuebadz-lemmas: $(REPORTTUEBADZLEMMAS)

test-tuebadz-coverage: $(REPORTTUEBADZCOVERAGE)

clean:
	$(RM) $(REPORTFILES)

.PHONY: all test-dwds-lemmas test-sample-lemmas test-tuebadz-lemmas test-tuebadz-coverage clean
