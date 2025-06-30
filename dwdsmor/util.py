from dwdsmor.tag import prev_boundary
from dwdsmor.traversal import Traversal


def inflected(spec, generated):
    traversal = Traversal.parse(
        spec, visible_boundaries=prev_boundary, boundary_tag="|"
    )
    if traversal.pos == "V" and traversal.nonfinite is None and prev_boundary in spec:
        parts = traversal.analysis.split("|")
        parts = parts[:-1]
        parts_length = sum(len(p) for p in parts)
        base = generated[parts_length:]
        return f"{base} {' '.join(parts)}"
    return generated
