# lexicon/sample/src/Makefile
# Andreas Nolda 2025-05-02

SAXON = java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform

SRCDIR    = $(CURDIR)/wb
SRCDIRS   = $(wildcard $(SRCDIR)/*)
AUXDIR    = $(CURDIR)/aux
LEXSRCDIR = $(abspath $(CURDIR)/../wb)
XSLDIR    = $(abspath $(CURDIR)/../../../share)

MANIFEST = $(CURDIR)/manifest.xml

LEXSRC = $(LEXSRCDIR)/open.xml

MANIFESTXSL   = $(XSLDIR)/dwds2manifest.xsl
LEXSRCXSL     = $(XSLDIR)/dwds2dwds.xsl
LIBXSL_COMMON = $(XSLDIR)/files.xsl

all: lexicon-src

lexicon-src: $(MANIFEST) $(LEXSRC)

$(MANIFEST): $(SRCDIRS) $(AUXDIR) $(MANIFESTXSL) $(LIBXSL_COMMON)
	$(SAXON) -xsl:$(MANIFESTXSL) -it -o:$@ dwds-dir=$(SRCDIR) aux-dir=$(AUXDIR)

$(LEXSRC): $(MANIFEST) $(SRCDIRS) $(AUXDIR) $(LEXSRCXSL) $(LIBXSL_COMMON)
	$(SAXON) -xsl:$(LEXSRCXSL) -it manifest-file=$(MANIFEST) > $@

clean:
	$(RM) $(LEXSRC)

.PHONY: all lexicon-src clean
