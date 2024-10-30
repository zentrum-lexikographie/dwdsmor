from .conftest import automata, is_edition_available


def test_automata():
    for edition in ["dev", "open", "dwds"]:
        if not is_edition_available(edition):
            continue
        edition_automata = automata(edition)
        for automaton_type in ("finite", "index", "lemma", "morph", "root"):
            analyzer = edition_automata.analyzer(automaton_type=automaton_type)
            generator = edition_automata.generator(automaton_type=automaton_type)
            for lemma, inflected in (("testen", "testet"),):
                for analyzed in analyzer.analyze(inflected):
                    assert analyzed.analysis == lemma
                    for generated in generator.generate(analyzed.spec):
                        assert inflected == generated.surface
                        break
        traversals = edition_automata.traversals()
        assert len(traversals.get("testen", [])) > 0
