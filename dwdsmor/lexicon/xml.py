import re


def dwds_qn(ln):
    return '{http://www.dwds.de/ns/1.0}' + ln


def text(el):
    if el is not None:
        txt = re.sub(r'\s+', ' ', el.text or '').strip()
        if txt != '':
            return txt
    return None
