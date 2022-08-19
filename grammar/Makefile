# Makefile
# Andreas Nolda 2022-08-19

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

DWDSMOR_MINIMAL = dwdsmor-minimal.fst
DWDSMOR_INDEX   = dwdsmor-index.fst

FST = $(DWDSMOR_MINIMAL) $(DWDSMOR_INDEX)

COMPILE = $(addsuffix .a,$(basename $(FST)))
COMPACT = $(addsuffix .ca,$(basename $(FST)))

TARGETS = $(COMPILE) $(COMPACT)

INCLUDE = symbols.fst map.fst flexion.fst markers.fst phon.fst elim.fst lemma.fst cleanup.fst

INCLUDE_INDEX = $(filter-out $(INCLUDE),lemma.fst) lemma-index.fst

INSTALL_DIR ?= lib

all: $(TARGETS)

%.ca: %.a
	$(FST_COMPACT) $< $@

%.a: %.fst
	$(FST_COMPILE) $< $@

$(DWDSMOR_MINIMAL): $(INCLUDE)

$(DWDSMOR_INDEX): $(INCLUDE_INDEX)

install: $(TARGETS)
	mkdir -p $(INSTALL_DIR)
	install -m 644 $(TARGETS) $(INSTALL_DIR)
	ln -sfr $(INSTALL_DIR)/$(addsuffix .a,$(basename $(DWDSMOR_MINIMAL))) $(INSTALL_DIR)/dwdsmor.a
	ln -sfr $(INSTALL_DIR)/$(addsuffix .ca,$(basename $(DWDSMOR_MINIMAL))) $(INSTALL_DIR)/dwdsmor.ca

clean:
	$(RM) $(TARGETS)

distclean: clean
	$(RM) -r $(INSTALL_DIR)

.PHONY: all install clean distclean
