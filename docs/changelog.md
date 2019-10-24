# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][kac] and this project adheres to
[Semantic Versioning][semver].

[kac]: https://keepachangelog.com/en/1.0.0/
[semver]: https://semver.org/

## [Unreleased]

### Added

* docs/changelog.md
* Help text for jlenv options: jlenv [<opts>] <command> [<args>]
* jlenv script fully refactored: functions for main, init, err, exit, setup etc.

### Changed

* Script is called through function $(main "$@")

### Fixed

* docs/plugins.md syntax

## [1.0.0] - 2019-10-21

This is the first release of the port from Ruby to [Julia](https://www.julialnag.org)

### Added

* Require GNU coreutils > 8.15 (Circa Jan 2012). 
* Extensive documentation (11 pages) in ./docs
* [Documentation](https://jlenv.github.io/jlenv) via GitHub Pages
* Submodules for test libraries.
* Build and code quality badges.

### Changed

* Removed native build of realpath.  Use GNU coreutils.
* Moved tests over to use bats-core, bats-assert, bats-file and bats support.
* Test for Julia binaries and applications (rails->genie, etc.)

### Fixed

* All tests broken by move to bats-core etc.
* Removed 'supports julia -S <cmd>' test: Not a Julia switch.

[Unreleased]: https://github.com/jlenv/jlenv/compare/1.0.0...HEAD
[1.0.0]: https://github.com/jlenv/jlenv/compare/0.0.0...1.0.0
