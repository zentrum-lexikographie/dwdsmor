# lexicon/dwds/Makefile
# Andreas Nolda 2023-06-26

SAXON = java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform

SRCDIR  = $(CURDIR)/wb
SRCDIRS = $(wildcard $(SRCDIR)/*)
AUXDIR  = $(CURDIR)/aux
LEXDIR  = $(CURDIR)
XSLDIR  = $(abspath $(CURDIR)/../../share)

INSTALLDIR = $(abspath $(CURDIR)/../../grammar)

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

all: lexicon

lexicon: $(MANIFEST) $(LEX)

$(MANIFEST): $(SRCDIRS) $(AUXDIR) $(MANIFESTXSL) $(LIBXSL_COMMON)
	$(SAXON) -xsl:$(MANIFESTXSL) -it -o:$@ dwds-dir=$(SRCDIR) aux-dir=$(AUXDIR) exclude-file=$(EXCLUDE)

$(LEX): $(SRCDIRS) $(AUXDIR) $(LEXXSL) $(LIBXSL_COMMON) $(LIBXSL_LEX)
	$(SAXON) -xsl:$(LEXXSL) -it manifest-file=$(MANIFEST) 2> $(LOG) | LC_ALL=C sort -u > $@

install: lexicon
	install -m 644 $(LEX) $(INSTALLDIR)

clean:
	$(RM) $(MANIFEST) $(LEX) $(LOG)

.PHONY: all lexicon install clean
