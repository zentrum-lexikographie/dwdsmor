from .conftest import automata_edition, is_edition_available


def test_automata():
    for edition in ["dev", "open", "dwds"]:
        if not is_edition_available(edition):
            continue
        automata = automata_edition(edition)
        for automaton_type in ("finite", "index", "lemma", "morph", "root"):
            analyzer = automata.analyzer(automaton_type=automaton_type)
            generator = automata.generator(automaton_type=automaton_type)
            for lemma, inflected in (("testen", "testet"),):
                for analyzed in analyzer.analyze(inflected):
                    assert analyzed.analysis == lemma
                    for generated in generator.generate(analyzed.spec):
                        assert inflected == generated.surface
                        break
        traversals = automata.traversals()
        assert len(traversals.get("testen", [])) > 0
