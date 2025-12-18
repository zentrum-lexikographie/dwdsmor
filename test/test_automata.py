import dwdsmor


def test_automata():
    for automaton_type in dwdsmor.automaton_types:
        analyzer = dwdsmor.analyzer(automaton_type=automaton_type)
        generator = dwdsmor.generator(automaton_type=automaton_type)
        for lemma, inflected in (("testen", "testet"),):
            for analyzed in analyzer.analyze(inflected):
                assert analyzed.analysis == lemma
                for generated in generator.generate(analyzed.spec):
                    assert inflected == generated.surface
                    break
        traversals = dwdsmor.traversals()
        assert len(traversals.get("testen", [])) > 0
