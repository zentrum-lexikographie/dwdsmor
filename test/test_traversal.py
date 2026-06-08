from dwdsmor import Traversal


def test_wb_count():
    t = Traversal(
        spec="Beruf<~>s<#>soldat<NN><Masc><Dat><Pl>",
        surface="Berufssoldat",
        analysis="Berufssoldat",
        weights=None,
        lidx=None,
        pidx=None,
        pos="NN",
        category=None,
        degree=None,
        function=None,
        person=None,
        gender="Masc",
        case="Dat",
        number="Pl",
        nonfinite=None,
        tense=None,
        mood=None,
        auxiliary=None,
        inflection=None,
        metainfo=None,
        orthinfo=None,
        charinfo=None,
        syninfo=None,
        ellipinfo=None,
        processes=None,
        means=None,
    )
    assert t.wb_count("#") == 1


def test_wb_count_ignore_symbols_not_in_boundary_tag():
    t = Traversal(
        spec="UN<=>-<#>Sicherheit<~>s<#>rat<NN><Masc><Dat><Sg>",
        surface="UN-Sicherheitsrat",
        analysis="UN-Sicherheitsrat",
        weights=None,
        lidx=None,
        pidx=None,
        pos="NN",
        category=None,
        degree=None,
        function=None,
        person=None,
        gender="Masc",
        case="Dat",
        number="Sg",
        nonfinite=None,
        tense=None,
        mood=None,
        auxiliary=None,
        inflection=None,
        metainfo=None,
        orthinfo=None,
        charinfo=None,
        syninfo=None,
        ellipinfo=None,
        processes=None,
        means=None,
    )
    assert t.wb_count("#-") == 2
