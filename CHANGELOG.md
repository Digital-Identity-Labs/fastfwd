# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2019-02-28
An embarrassing bug fix and code improvements. Should now compile on Elixir 1.10+

### Added
- `Tags.to_string` will concatenate list of tag atoms to a string

### Fixed
- Fastfwd could not compile on recent Elixir versions because of bad syntax in a 'try' block. 
  The lesson here is to avoid accidentally writing Ruby in an Elixir library, and to test with
  the latest Elixir.
  
### Changed 
- Tests and documentation examples now sort results because the first `mix test` after 
  compilation would always fail as the order of example data would change slightly. 

## [0.1.1] - 2019-02-28
Documentation improvements

### Added
- Changelog.md, trying a different format for this project (see top)
- Code of Conduct, using Github's default.

### Changed
- Improved Readme with better examples
- *Almost* complete API docs
- Fixed Dialyzer version
- Improved Typespecs

## [0.1.0] - 2019-02-25
Initial release

[0.2.0]: https://github.com/Digital-Identity-Labs/fastfwd/compare/0.1.1...0.2.0
[0.1.1]: https://github.com/Digital-Identity-Labs/fastfwd/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/Digital-Identity-Labs/fastfwd/compare/releases/tag/0.1.0