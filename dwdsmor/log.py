import logging
import os
import sys


def configure_logging():
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        stream=sys.stderr,
        level=(logging.DEBUG if os.getenv("DEBUG") else logging.INFO),
    )
