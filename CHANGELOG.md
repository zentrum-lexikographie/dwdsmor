# Changelog

## [0.9.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.8.0...v0.9.0) (2025-07-07)


### Features

* add --no-info option to tools/analysis.py ([cf06934](https://github.com/zentrum-lexikographie/dwdsmor/commit/cf069345d067bf7fd3869fca90a1ef6935a37d01))
* add support for conversion of infinitives ([48177ad](https://github.com/zentrum-lexikographie/dwdsmor/commit/48177adb34458af9dde2c53f9627b1e4a10bd4a9))
* add support for conversion of inflected adjectives ([3f13871](https://github.com/zentrum-lexikographie/dwdsmor/commit/3f13871aa14f04e34fa7974c51c6075d832f6ed7))


### Bug Fixes

* correct some XPaths ([0cc9e46](https://github.com/zentrum-lexikographie/dwdsmor/commit/0cc9e46f2440b5a8731424ac98945170a376b3ce))
* do not output redundant surface key in tools/analysis.py ([e7cb22b](https://github.com/zentrum-lexikographie/dwdsmor/commit/e7cb22b11a9fa7f3639dee5d3c0c1c785bc4f06f))
* improve error handling of Python tools ([539d7dd](https://github.com/zentrum-lexikographie/dwdsmor/commit/539d7dda74d9beed1d40766331e79ac585653a98))

## [0.8.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.7.0...v0.8.0) (2025-07-02)


### Features

* add support for colloquial mixed variants of weak masculine nouns ([ea0dacd](https://github.com/zentrum-lexikographie/dwdsmor/commit/ea0dacddf6f70170e04e1b4a2ac3b7c9e15cb75a))
* improve coverage measure for DWDS lemma generation ([3a78101](https://github.com/zentrum-lexikographie/dwdsmor/commit/3a78101a0885e191f732c8039dddb9d8e809e4b9))


### Bug Fixes

* make the edition argument of the build script optional again ([469307f](https://github.com/zentrum-lexikographie/dwdsmor/commit/469307f309b40533e2ff7afd73ceadefe6bb34d5))


### Documentation

* clarify README.md ([31ebdbc](https://github.com/zentrum-lexikographie/dwdsmor/commit/31ebdbcba00e261594cd10845f8ca3cfeb5bd33f))

## [0.7.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.6.0...v0.7.0) (2025-07-01)


### Features

* add support for index and root automata to command-line interface ([b523a2b](https://github.com/zentrum-lexikographie/dwdsmor/commit/b523a2b897082002d776dddcbf9b4d594750d353))
* add support for proper names classified as nouns in DWDS articles ([a593692](https://github.com/zentrum-lexikographie/dwdsmor/commit/a593692f6c62bb710890f13d7338aa05e2a99e55))
* exclude "sein" as a basis for preverb prefixation ([836d09b](https://github.com/zentrum-lexikographie/dwdsmor/commit/836d09ba023a61b51342d6c0af850447f0ab1499))
* exclude abbreviated bases for preverb prefixation ([c7e0225](https://github.com/zentrum-lexikographie/dwdsmor/commit/c7e0225c9b0f447f2812cefdfda585de59950c8a))


### Bug Fixes

* mark truncated and separated preverbs with the same categories ([9f340c1](https://github.com/zentrum-lexikographie/dwdsmor/commit/9f340c1ee77c6f8199d232f961db01926dca4b48))


### Documentation

* also mention development edition in README.md ([c158612](https://github.com/zentrum-lexikographie/dwdsmor/commit/c158612ea95a36bd9d112f066341ed1f464ee1d6))
* further enhance README.md ([94b1ecd](https://github.com/zentrum-lexikographie/dwdsmor/commit/94b1ecd48b6602bd7ca9369c888b60c26354b27d))
* improve wording in README.md ([377a853](https://github.com/zentrum-lexikographie/dwdsmor/commit/377a853c29e9757a105f4409ed504b4023dfde92))
* provide Hugging Face links for the DWDS Edition and the Open Edition ([f32a3b8](https://github.com/zentrum-lexikographie/dwdsmor/commit/f32a3b8d3b173c68ba770a4263f07da367f0232b))
* update README.md ([facfaa7](https://github.com/zentrum-lexikographie/dwdsmor/commit/facfaa757e81329c9668f7bddcf40ee7306ca61a))

## [0.6.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.5.0...v0.6.0) (2025-05-30)


### Features

* add 'syninfo' to criteria ([195d75c](https://github.com/zentrum-lexikographie/dwdsmor/commit/195d75c14e4829c8a90bef8e2851242d0d7b5be2))
* add 'syninfo' to criteria ([9b85c11](https://github.com/zentrum-lexikographie/dwdsmor/commit/9b85c11bdc97ed2ff59563dd23c12bfd20a4d2d9))
* mark more archaic past forms as &lt;Old&gt; ([035f23c](https://github.com/zentrum-lexikographie/dwdsmor/commit/035f23c048b4085787c76e2c75075574c9909931))


### Bug Fixes

* pass 'syninfo' attribute to criteria use in spaCy lemmatization component ([7b8b630](https://github.com/zentrum-lexikographie/dwdsmor/commit/7b8b630230ccc3727919ba151c9bde463355b26b))
* pass 'syninfo' attribute to criteria use in spaCy lemmatization component ([7c51542](https://github.com/zentrum-lexikographie/dwdsmor/commit/7c515427457b1d409ce3e964368c05d25730079b))


### Miscellaneous Chores

* update XSLT stylesheets and lexicon XML files to DWDS schema ([ac143fd](https://github.com/zentrum-lexikographie/dwdsmor/commit/ac143fd69f82a13dcc082a9b898cfa80ea0e09e2))

## [0.5.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.4.0...v0.5.0) (2025-05-12)


### Bug Fixes

* add missing parentheses ([a2ce0ea](https://github.com/zentrum-lexikographie/dwdsmor/commit/a2ce0ea77836bdbb2aa3ddc2e680ba7198306cde))
* do not delete stem-final schwa in "mittler-" ([bdcaf92](https://github.com/zentrum-lexikographie/dwdsmor/commit/bdcaf9259f7d024e6f6bf7c58514d43e963f1619))


### Performance Improvements

* optimize automata by fronting ellipsis and syntax tags ([e8c6170](https://github.com/zentrum-lexikographie/dwdsmor/commit/e8c61705de66660f72aadfe48a5d6d62d38aa595))
* optimize automata by fronting orthography tags ([0a27286](https://github.com/zentrum-lexikographie/dwdsmor/commit/0a27286267c5d81f23f3f984eda983ef3ae6b06f))

## [0.4.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.3.2...v0.4.0) (2025-05-02)


### Features

* add inflection class for colloquial inflection of "Quiz" ([c087f58](https://github.com/zentrum-lexikographie/dwdsmor/commit/c087f583e1d251b89f82ad78ef2098332b2fd5e2))
* add initial support for measure nouns ([681f0f6](https://github.com/zentrum-lexikographie/dwdsmor/commit/681f0f6ecbd3f491f68004971a6130bc6069804d))
* add support for additional cases of loan-word inflection ([0ac5232](https://github.com/zentrum-lexikographie/dwdsmor/commit/0ac5232796ad6197788b77086c799f6700b7c476))
* add support for more nouns with suppletive plural forms ([f3bc818](https://github.com/zentrum-lexikographie/dwdsmor/commit/f3bc8183bf9bb446f54d28f975fbf13ef775b906))
* add support for non-standard contracted adpositions ([aed0251](https://github.com/zentrum-lexikographie/dwdsmor/commit/aed0251d12c21b7f4caf105f0907d5da38421dd1))
* add support for separated parts of separable verbs ([354e283](https://github.com/zentrum-lexikographie/dwdsmor/commit/354e283c9087f4144e71dfc5bcd9a6a34059b917))
* add support for uninflected verbs with infinitive only ([89d6e5c](https://github.com/zentrum-lexikographie/dwdsmor/commit/89d6e5c80e0d946e10035dc6751fbdc85e492405))
* port tools from master branch ([3299523](https://github.com/zentrum-lexikographie/dwdsmor/commit/32995230a389877bebd4c4a0ade7c85bea8df8e1))
* reduce number of analyses of separated verbs by the "root" transducer ([fa4b201](https://github.com/zentrum-lexikographie/dwdsmor/commit/fa4b201165b77fbbd370b291b0874c908c586c3d))
* update analysis.py for separated parts of separable verbs ([07f3934](https://github.com/zentrum-lexikographie/dwdsmor/commit/07f3934d9f040e282fb44f9030eb6a1039fa331f))


### Bug Fixes

* classify "Cl" and "NonCl" as function tags as in the master branch ([79c53ff](https://github.com/zentrum-lexikographie/dwdsmor/commit/79c53fffccd67b063c3d6665e6ed1ede6763216e))
* do not sort results globally in command-line interface ([ec851ca](https://github.com/zentrum-lexikographie/dwdsmor/commit/ec851caed9f518899a79a63392c14859c893a59b))
* exclude "worden" as a conversion basis ([3a5ae43](https://github.com/zentrum-lexikographie/dwdsmor/commit/3a5ae43e0a554292c4a2ffdd8db7a9c59d980ef3))
* fix regression in regression-test snapshot creation ([dfa84af](https://github.com/zentrum-lexikographie/dwdsmor/commit/dfa84af8bcf37b96b5ff8b022058ae983092417d))
* list all word-formation means tags supported by the "root" tranducer ([904f9df](https://github.com/zentrum-lexikographie/dwdsmor/commit/904f9df3dc9c70d021c060051d58d77460ef6c22))
* set analyzer automaton to "lemma" in command-line interface ([3e75780](https://github.com/zentrum-lexikographie/dwdsmor/commit/3e75780d1444add92b9a8dff7da75d850dac126c))
* update regression test for nominal compounds with verbal bases ([a5c9d17](https://github.com/zentrum-lexikographie/dwdsmor/commit/a5c9d17fef15f26fb176c8af3c512576444c38eb))
* update regression test snapshot ([7870e2f](https://github.com/zentrum-lexikographie/dwdsmor/commit/7870e2fb8522561503c7d866477ada9369fec390))

## [0.3.2](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.3.1...v0.3.2) (2025-04-03)


### Bug Fixes

* actually pick up CLI parameter choosing automata location ([0edeece](https://github.com/zentrum-lexikographie/dwdsmor/commit/0edeeceb19c68041c8e0a0d4162640d18b832e38))

## [0.3.1](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.3.0...v0.3.1) (2025-04-03)


### Bug Fixes

* add parameters to choose automata on CLI (fixes [#14](https://github.com/zentrum-lexikographie/dwdsmor/issues/14)) ([5c25b95](https://github.com/zentrum-lexikographie/dwdsmor/commit/5c25b95eba2375c0115913a04caccbe628704797))
* correct inflection tag sequence for adverbs ([f1ad8bb](https://github.com/zentrum-lexikographie/dwdsmor/commit/f1ad8bb4f4d22b35466d9605313ba5352b931003))
* use more flexible automaton "finite" for lemmatization on CLI ([efd811d](https://github.com/zentrum-lexikographie/dwdsmor/commit/efd811d37def620df3fc68c0f1271d5db1b52a4c))

## [0.3.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.2.1...v0.3.0) (2025-03-28)


### Features

* **Lexicon:** Update DWDS lexicon ([02c69f5](https://github.com/zentrum-lexikographie/dwdsmor/commit/02c69f57bf6bc5a76c916bca92922fd00ef2d6a2))
* **Paradigm Generation:** handle separable verbs ([f584277](https://github.com/zentrum-lexikographie/dwdsmor/commit/f58427721c9360a6eb211676e32649fc4897ed82))

## [0.2.1](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.2.0...v0.2.1) (2025-01-27)


### Bug Fixes

* **Project:** Remove spaCy model dependency (blocks PyPI publication) ([b6f5e97](https://github.com/zentrum-lexikographie/dwdsmor/commit/b6f5e977be5e520f67ff4d874388428e13883c75))

## [0.2.0](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.1.1...v0.2.0) (2025-01-27)


### Features

* Add spaCy integration as single-threaded pipeline component ([d549219](https://github.com/zentrum-lexikographie/dwdsmor/commit/d549219dc8b929b503cc79e8be2a0a2a12cc7625))

## [0.1.1](https://github.com/zentrum-lexikographie/dwdsmor/compare/v0.1.0...v0.1.1) (2025-01-21)


### Bug Fixes

* **GitHub Actions:** Add quotes to Python version in publish workflow ([4620672](https://github.com/zentrum-lexikographie/dwdsmor/commit/4620672417467493545ea978fa91a262071751a3))

## 0.1.0 (2025-01-21)


### ⚠ BREAKING CHANGES

* HuggingFace Hub integration

### Features

* add Python library ([3d2d513](https://github.com/zentrum-lexikographie/dwdsmor/commit/3d2d5133ae44b81e431e63bc9ed58800c12985a2))
* HuggingFace Hub integration ([83d57e0](https://github.com/zentrum-lexikographie/dwdsmor/commit/83d57e08bc5af6bcea3794e3ec3e3993c894f895))
* measure coverage via UD/de-hdt ([3d2d513](https://github.com/zentrum-lexikographie/dwdsmor/commit/3d2d5133ae44b81e431e63bc9ed58800c12985a2))
* provide automata edition via Hugging Face Hub ([3d2d513](https://github.com/zentrum-lexikographie/dwdsmor/commit/3d2d5133ae44b81e431e63bc9ed58800c12985a2))
* refactor build system ([3d2d513](https://github.com/zentrum-lexikographie/dwdsmor/commit/3d2d5133ae44b81e431e63bc9ed58800c12985a2))


### Miscellaneous Chores

* release 0.1.0 ([3d2d513](https://github.com/zentrum-lexikographie/dwdsmor/commit/3d2d5133ae44b81e431e63bc9ed58800c12985a2))
