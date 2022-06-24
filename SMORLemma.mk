# SMORLemma.mk
# Andreas Nolda 2022-06-24

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

TARGETS = smor.a smor.ca smor-minimal.a smor-minimal.ca \
	smor-full.a smor-full.ca smor-cap.a smor-cap.ca smor-uc.a smor-uc.ca

INSTALL_DIR ?= lib

all: $(TARGETS)

smor-gen.a: smor.a

smor.a: elim-disj.a smor-lfg.a

smor-minimal.a: lexicon/lexicon elim-disj.a elimX.a map1.a map2.a map3.a \
	infixfilter.a komposfilter.a uplow.a

smor-full.a: symbols.fst elim-disj.a morph-lemma.a smor-guesser.a

smor-cap.a: symbols.fst morph-lemma.a

smor-uc.a smor-ascii.a smor-ss.a: morph-lemma.a

smor-guesser.a: lexicon/guesser.lex symbols.fst flexion.fst sufffilter.fst phon.fst \
	elim-disj.a elimX.a map1.a map2.a infixfilter.a komposfilter.a uplow.a

smor-lfg.a: symbols.fst morph-lemma.a

morph-lemma.a: symbols.fst morph2.a

morph2.a: elim-disj.a morph.a

morph.a: basemorph.a elimX.a

basemorph.a: lexicon/lexicon symbols.fst FIX.fst NUM.fst PRO.fst \
	defaults.fst flexion.fst phon.fst sufffilter.fst \
	map1.a map2.a map3.a infixfilter.a komposfilter.a preffilter.a uplow.a

PRO.fst: lexicon/pro.lex

elim-disj.a elimX.a map1.a map2.a map3.a: symbols.fst

preffilter.a infixfilter.a komposfilter.a uplow.a: symbols.fst

%.a: %.fst
	$(FST_COMPILE) $< $@

%.ca: %.a
	$(FST_COMPACT) $< $@

install: $(TARGETS)
	mkdir -p $(INSTALL_DIR)
	install -m 644 $(TARGETS) $(INSTALL_DIR)

.PHONY: all install
