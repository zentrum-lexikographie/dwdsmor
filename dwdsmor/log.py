import logging
import os
import sys

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    stream=sys.stderr,
    level=(logging.DEBUG if os.getenv("DEBUG") else logging.INFO),
)

logger = logging.getLogger("dwdsmor")

__all__ = ["logger"]
