# tests/Makefile
# Andreas Nolda 2023-09-29

PYTEST = py.test -v -v -s -x

TESTDIR   = $(CURDIR)
REPORTDIR = $(abspath $(CURDIR)/../test-reports)

TESTDWDS     = $(TESTDIR)/test_dwds_coverage.py
TESTSAMPLE   = $(TESTDIR)/test_sample_coverage.py
TESTTUEBADZ  = $(TESTDIR)/test_tuebadz_coverage.py
TESTTUEBADZ2 = $(TESTDIR)/test_tuebadz_lemmatisation.py

REPORTDWDS     = $(REPORTDIR)/dwds-coverage.tsv
REPORTSAMPLE   = $(REPORTDIR)/sample-coverage.tsv
REPORTTUEBADZ  = $(REPORTDIR)/tuebadz-coverage.tsv
REPORTTUEBADZ2 = $(REPORTDIR)/tuebadz-lemmatisation.tsv

REPORTFILES = $(REPORTDWDS) \
              $(REPORTSAMPLE) \
              $(REPORTTUEBADZ) \
              $(REPORTTUEBADZ2)

all: test-dwds test-sample test-tuebadz

test-dwds: $(REPORTDWDS)

test-sample: $(REPORTSAMPLE)

test-tuebadz: $(REPORTTUEBADZ) $(REPORTTUEBADZ2)

$(REPORTDWDS): $(TESTDWDS)
	$(PYTEST) $(TESTDWDS)

$(REPORTSAMPLE): $(TESTSAMPLE)
	$(PYTEST) $(TESTSAMPLE)

$(REPORTTUEBADZ): $(TESTTUEBADZ)
	$(PYTEST) $(TESTTUEBADZ)

$(REPORTTUEBADZ2): $(TESTTUEBADZ2)
	$(PYTEST) $(TESTTUEBADZ2)

clean:
	$(RM) $(REPORTFILES)

.PHONY: all test-dwds test-sample test-tuebadz clean
