# tests/Makefile
# Andreas Nolda 2023-11-24

PYTEST = py.test --no-header

PYTEST_RUN    = $(PYTEST) -q
PYTEST_UPDATE = $(PYTEST) -q -W ignore --snapshot-update
PYTEST_DIFF   = $(PYTEST) -v -v

TESTDIR    = $(CURDIR)
REPORTDIR  = $(TESTDIR)/reports
SUMMARYDIR = $(TESTDIR)/summaries
INSTALLDIR = $(abspath $(TESTDIR)/../lib)

TEST_DWDS_LEMMA_COVERAGE       = $(TESTDIR)/test_dwds_lemma_coverage.py
TEST_SAMPLE_LEMMA_COVERAGE     = $(TESTDIR)/test_sample_lemma_coverage.py
TEST_TUEBADZ_LEMMA_COVERAGE    = $(TESTDIR)/test_tuebadz_lemma_coverage.py
TEST_DWDS_PARADIGM_COVERAGE    = $(TESTDIR)/test_dwds_paradigm_coverage.py
TEST_SAMPLE_PARADIGM_COVERAGE  = $(TESTDIR)/test_sample_paradigm_coverage.py
TEST_GESETZE_ANALYSIS_SNAPSHOT = $(TESTDIR)/test_gesetze_analysis_snapshot.py
TEST_PARADIGM_SNAPSHOT        = $(TESTDIR)/test_paradigm_snapshot.py

LIB_DWDS_COVERAGE    = $(TESTDIR)/dwds_coverage.py
LIB_TUEBADZ_COVERAGE = $(TESTDIR)/tuebadz_coverage.py
LIB_SNAPSHOT         = $(TESTDIR)/snapshot.py

REPORT_DWDS_LEMMA_COVERAGE       = $(REPORTDIR)/dwds-lemma-coverage.tsv
REPORT_SAMPLE_LEMMA_COVERAGE     = $(REPORTDIR)/sample-lemma-coverage.tsv
REPORT_TUEBADZ_LEMMA_COVERAGE    = $(REPORTDIR)/tuebadz-lemma-coverage.tsv
REPORT_DWDS_PARADIGM_COVERAGE    = $(REPORTDIR)/dwds-paradigm-coverage.tsv
REPORT_SAMPLE_PARADIGM_COVERAGE  = $(REPORTDIR)/sample-paradigm-coverage.tsv
REPORT_GESETZE_ANALYSIS_SNAPSHOT = $(REPORTDIR)/gesetze-analysis-snapshot.tsv
REPORT_PARADIGM_SNAPSHOT         = $(REPORTDIR)/adjective-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/article-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/cardinal-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/demonstrative-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/indefinite-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/interrogative-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/name-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/noun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/ordinal-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/personal-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/possessive-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/relative-pronoun-paradigm-snapshot.tsv \
                                   $(REPORTDIR)/verb-paradigm-snapshot.tsv

REPORTFILES_COVERAGE = $(REPORT_DWDS_LEMMA_COVERAGE) \
                       $(REPORT_SAMPLE_LEMMA_COVERAGE) \
                       $(REPORT_TUEBADZ_LEMMA_COVERAGE) \
                       $(REPORT_DWDS_PARADIGM_COVERAGE) \
                       $(REPORT_SAMPLE_PARADIGM_COVERAGE)

REPORTFILES_SNAPSHOT = $(REPORT_GESETZE_ANALYSIS_SNAPSHOT) \
                       $(REPORT_PARADIGM_SNAPSHOT)

SUMMARY_DWDS_LEMMA_COVERAGE      = $(SUMMARYDIR)/dwds-lemma-coverage.tsv
SUMMARY_SAMPLE_LEMMA_COVERAGE    = $(SUMMARYDIR)/sample-lemma-coverage.tsv
SUMMARY_TUEBADZ_LEMMA_COVERAGE   = $(SUMMARYDIR)/tuebadz-lemma-coverage.tsv
SUMMARY_DWDS_PARADIGM_COVERAGE   = $(SUMMARYDIR)/dwds-paradigm-coverage.tsv
SUMMARY_SAMPLE_PARADIGM_COVERAGE = $(SUMMARYDIR)/sample-paradigm-coverage.tsv

SUMMARYFILES_COVERAGE = $(SUMMARY_DWDS_LEMMA_COVERAGE) \
                        $(SUMMARY_SAMPLE_LEMMA_COVERAGE) \
                        $(SUMMARY_TUEBADZ_LEMMA_COVERAGE) \
                        $(SUMMARY_DWDS_PARADIGM_COVERAGE) \
                        $(SUMMARY_SAMPLE_PARADIGM_COVERAGE)

DWDSMOR_A       = $(INSTALLDIR)/dwdsmor.a
DWDSMOR_CA      = $(INSTALLDIR)/dwdsmor.ca
DWDSMOR_INDEX_A = $(INSTALLDIR)/dwdsmor-index.a

test-coverage: test-dwds-lemma-coverage test-sample-lemma-coverage test-tuebadz-lemma-coverage \
               test-dwds-paradigm-coverage test-sample-paradigm-coverage

test-snapshot: test-analysis-snapshot test-paradigm-snapshot

test-regression: test-analysis-regression test-paradigm-regression

test-dwds-lemma-coverage: $(REPORT_DWDS_LEMMA_COVERAGE)

test-sample-lemma-coverage: $(REPORT_SAMPLE_LEMMA_COVERAGE)

test-tuebadz-lemma-coverage: $(REPORT_TUEBADZ_LEMMA_COVERAGE)

test-dwds-paradigm-coverage: $(REPORT_DWDS_PARADIGM_COVERAGE)

test-sample-paradigm-coverage: $(REPORT_SAMPLE_PARADIGM_COVERAGE)

test-analysis-snapshot: $(REPORT_GESETZE_ANALYSIS_SNAPSHOT)

test-paradigm-snapshot: $(REPORT_PARADIGM_SNAPSHOT)

test-analysis-regression:
	$(PYTEST_DIFF) $(TEST_GESETZE_ANALYSIS_SNAPSHOT)

test-paradigm-regression:
	$(PYTEST_DIFF) $(TEST_PARADIGM_SNAPSHOT)

$(REPORT_DWDS_LEMMA_COVERAGE): $(TEST_DWDS_LEMMA_COVERAGE) $(LIB_DWDS_COVERAGE) $(DWDSMOR_CA)
	$(PYTEST_RUN) $(TEST_DWDS_LEMMA_COVERAGE)

$(REPORT_SAMPLE_LEMMA_COVERAGE): $(TEST_SAMPLE_LEMMA_COVERAGE) $(LIB_DWDS_COVERAGE) $(DWDSMOR_CA)
	$(PYTEST_RUN) $(TEST_SAMPLE_LEMMA_COVERAGE)

$(REPORT_TUEBADZ_LEMMA_COVERAGE): $(TEST_TUEBADZ_LEMMA_COVERAGE) $(LIB_TUEBADZ_COVERAGE) $(DWDSMOR_CA)
	$(PYTEST_RUN) $(TEST_TUEBADZ_LEMMA_COVERAGE)

$(REPORT_DWDS_PARADIGM_COVERAGE): $(TEST_DWDS_PARADIGM_COVERAGE) $(LIB_DWDS_COVERAGE) $(DWDSMOR_INDEX_A)
	$(PYTEST_RUN) $(TEST_DWDS_PARADIGM_COVERAGE)

$(REPORT_SAMPLE_PARADIGM_COVERAGE): $(TEST_SAMPLE_PARADIGM_COVERAGE) $(LIB_DWDS_COVERAGE) $(DWDSMOR_INDEX_A)
	$(PYTEST_RUN) $(TEST_SAMPLE_PARADIGM_COVERAGE)

$(REPORT_GESETZE_ANALYSIS_SNAPSHOT): $(TEST_GESETZE_ANALYSIS_SNAPSHOT) $(LIB_SNAPSHOT) $(DWDSMOR_A)
	$(PYTEST_UPDATE) $(TEST_GESETZE_ANALYSIS_SNAPSHOT)

$(REPORT_PARADIGM_SNAPSHOT) &: $(TEST_PARADIGM_SNAPSHOT) $(LIB_SNAPSHOT) $(DWDSMOR_INDEX_A)
	$(PYTEST_UPDATE) $(TEST_PARADIGM_SNAPSHOT)

clean:
	$(RM) $(REPORTFILES_COVERAGE) $(SUMMARYFILES_COVERAGE)

distclean: clean
	$(RM) $(REPORTFILES_SNAPSHOT)

.PHONY: test-coverage test-snapshot test-regression \
        test-dwds-lemma-coverage test-sample-lemma-coverage test-tuebadz-lemma-coverage \
        test-dwds-paradigm-coverage test-sample-paradigm-coverage \
        test-analysis-snapshot test-paradigm-snapshot \
        test-analysis-regression test-paradigm-regression \
        clean distclean
