def is_current(target, sources):
    "Check whether a target file is current, given the mtime of its sources."
    if not target.exists():
        return False
    target_m_time = target.stat().st_mtime
    return not any((target_m_time < source.stat().st_mtime for source in sources))
