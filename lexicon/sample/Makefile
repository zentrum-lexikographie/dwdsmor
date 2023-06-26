# lexicon/sample/Makefile
# Andreas Nolda 2023-06-26

SAXON = java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform
DIFF  = diff -s -y -Z --suppress-common-lines -W 120

SRCDIR  = $(CURDIR)/wb
LEXDIR  = $(CURDIR)
XSLDIR  = $(abspath $(CURDIR)/../../share)

INSTALLDIR = $(abspath $(CURDIR)/../../grammar)

MANIFEST = $(CURDIR)/manifest.xml

LEXSRC = $(SRCDIR)/dwds.xml

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

$(MANIFEST): $(LEXSRC) $(MANIFESTXSL) $(LIBXSL_COMMON)
	$(SAXON) -xsl:$(MANIFESTXSL) -it -o:$@ dwds-dir=$(SRCDIR)

$(LEX): $(LEXSRC) $(LEXXSL) $(LIBXSL_COMMON) $(LIBXSL_LEX)
	$(SAXON) -xsl:$(LEXXSL) -it manifest-file=$(MANIFEST) 2> $(LOG) | LC_ALL=C sort -u > $@

install: lexicon
	install -m 644 $(LEX) $(INSTALLDIR)

clean: testclean
	$(RM) $(MANIFEST) $(LEX) $(LOG)

.PHONY: all lexicon install clean
