import dwdsmor


def test_lemmatizer():
    lemmatizer = dwdsmor.lemmatizer()
    assert lemmatizer("getestet", pos={"+V"}) == "testen"
    assert lemmatizer("getestet", pos={"+ADJ"}) == "getestet"
