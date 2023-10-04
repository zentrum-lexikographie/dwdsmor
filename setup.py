from pathlib import Path

from setuptools import find_packages, setup

version = (Path(__file__) / ".." / "VERSION").resolve().read_text().strip()

setup(name="dwdsmor",
      version=version,
      description="SFST/SMOR/DWDS-based German morphology",
      author="Berlin-Brandenburg Academy of Sciences and Humanities",
      author_email="zdl-it@zdl.org",
      license="LGPLv3",
      packages=find_packages(exclude=["tests"]),
      python_requires=">=3.9",
      install_requires=["sfst-transduce"],
      extras_require={"cli": ["blessings"],
                      "test": ["pytest", "syrupy"]})
