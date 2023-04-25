# Makefile
# Andreas Nolda 2023-04-25

SAXON = java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform
DIFF  = diff -s -y -Z --suppress-common-lines -W 120

SRCDIR  = $(CURDIR)/wb
SRCDIRS = $(wildcard $(SRCDIR)/*)
AUXDIR  = $(CURDIR)/aux
LEXDIR  = $(abspath $(CURDIR)/../grammar)
XSLDIR  = $(abspath $(CURDIR)/../share)
TESTDIR = $(CURDIR)/test

MANIFEST = $(CURDIR)/manifest.xml
EXCLUDE  = $(CURDIR)/exclude.xml

LEX = $(LEXDIR)/dwds.lex
LOG = $(LEXDIR)/dwds.log

MANIFESTXSL   = $(XSLDIR)/dwds2manifest.xsl
LEXXSL        = $(XSLDIR)/dwds2dwdsmor.xsl
LIBXSL_COMMON = $(XSLDIR)/files.xsl
LIBXSL_LEX    = $(XSLDIR)/categories.xsl \
                $(XSLDIR)/entries.xsl \
                $(XSLDIR)/forms.xsl \
                $(XSLDIR)/strings.xsl

TESTINPUT  = $(TESTDIR)/input
TESTOUTPUT = $(TESTDIR)/output
TESTTARGET = $(TESTDIR)/target

TESTINPUTS  = $(wildcard $(TESTINPUT)/*.xml)
TESTOUTPUTS = $(patsubst $(TESTINPUT)/%.xml,$(TESTOUTPUT)/%.lex,$(TESTINPUTS))

all: lexicon

lexicon: $(MANIFEST) $(LEX)

$(MANIFEST): $(SRCDIRS) $(AUXDIR) $(MANIFESTXSL) $(LIBXSL_COMMON)
	$(SAXON) -xsl:$(MANIFESTXSL) -it -o:$@ dwds-dir=$(SRCDIR) aux-dir=$(AUXDIR) exclude-file=$(EXCLUDE)

$(LEX): $(SRCDIRS) $(AUXDIR) $(LEXXSL) $(LIBXSL_COMMON) $(LIBXSL_LEX)
	$(SAXON) -xsl:$(LEXXSL) -it manifest-file=$(MANIFEST) 2> $(LOG) | LC_ALL=C sort -u > $@

test: $(TESTOUTPUTS)

$(TESTOUTPUT):
	mkdir -p $@

$(TESTOUTPUT)/%: $(TESTTARGET)/% $(LEXXSL) $(LEXLIB) $(TESTINPUTS) | $(TESTOUTPUT)
	$(SAXON) -xsl:$(LEXXSL) -it manifest-file=$(patsubst $(TESTTARGET)/%.lex,$(TESTINPUT)/%.xml,$<) 2> /dev/null | LC_ALL=C sort -u > $@
	@$(DIFF) $< $@ || true

clean: testclean
	$(RM) $(MANIFEST) $(LEX) $(LOG)

testclean:
	$(RM) $(TESTOUTPUTS)

.PHONY: all lexicon test clean testclean
