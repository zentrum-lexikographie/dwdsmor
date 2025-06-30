import dwdsmor


def test_lemmatizer():
    lemmatizer = dwdsmor.lemmatizer()
    assert lemmatizer("getestet", pos={"V"}).analysis == "testen"
    assert lemmatizer("getestet", pos={"ADJ"}).analysis == "getestet"
