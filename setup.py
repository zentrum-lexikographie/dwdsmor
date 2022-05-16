from pathlib import Path
from setuptools import setup, find_packages

version = (Path(__file__) / '..' / 'VERSION').resolve().read_text().strip()

setup(
    name='dwdsmor',
    version=version,
    description='SFST/SMOR/DWDS-based German morphology',
    author='Berlin-Brandenburg Academy of Sciences and Humanities',
    author_email='zdl-it@zdl.org',
    license='LGPLv3',
    packages=find_packages(exclude=['tests']),
    install_requires=[
        'sfst-transduce',
        'jellyfish',
    ],
    extras_require={
        'dwdsmor': [
            'blessings'
        ],
        'test': [
            'pytest',
            'autoflake',
            'flake8',
            'dvc[ssh]'
        ]
    }
)
