# download template:
#
# https://github.com/flairNLP/flair/blob/master/flair/file_utils.py#L228-L274

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Union

from sfst_transduce import CompactTransducer, Transducer


def get_default_repository_dir() -> Path:
    return Path(os.environ.get("DWDSMOR_AUTOMATA_DIR", "."))


@dataclass
class Automata:
    dir: Path = field(default_factory=get_default_repository_dir)

    def transducer(
        self, edition="open", automaton_type="lemma", generate=True, both_layers=False
    ) -> Union[Transducer, CompactTransducer]:
        file_suffix = "a" if generate else "ca"
        transducer_file = Path(self.dir) / edition / f"{automaton_type}.{file_suffix}"
        assert transducer_file.is_file(), f"{transducer_file} does not exist"
        if not generate:
            transducer = CompactTransducer(transducer_file.as_posix())
            transducer.both_layers = both_layers
            return transducer
        else:
            return Transducer(transducer_file.as_posix())
