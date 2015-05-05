# dart_codecov [![Build Status](https://travis-ci.org/ekweible/dart_codecov.svg?branch=master)](https://travis-ci.org/ekweible/dart_codecov) [![codecov.io](http://codecov.io/github/ekweible/dart_codecov/coverage.svg?branch=master)](http://codecov.io/github/ekweible/dart_codecov?branch=master)
> Send coverage reports to codecov.io (lcov, gcov, or json). Integrates with travis-ci.


## Installation

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  dart_codecov: '>=0.1.0 <0.2.0'
```

Install:
```
pub get
```


## Usage
```
pub run dart_codecov coverage.lcov
```


## Supported Coverage Formats
[Codecov.io's API](https://codecov.io/api) currently supports `lcov`, `gcov`, and `json` formats. As long as the file you supply is in one of these formats, coverage reporting should work.

Examples:
```
pub run dart_codecov coverage.lcov
pub run dart_codecov coverage.gcov
pub run dart_codecov coverage.json
```


## Configuration
By default, this tool assumes that it's running on travis-ci and will grab all necessary information from environment variables.
**You will need to add your codecov.io token as a secure environment variable on travis-ci with the name `CODECOV_TOKEN`.**

### Options
- `--commit`: commit sha, defaults to `TRAVIS_COMMIT` environment variable (set by travis-ci).
- `--branch`: branch name, defaults to `TRAVIS_BRANCH` environment variable (set by travis-ci).
- `--token`: codecov.io repo token, defaults to `CODECOV_TOKEN` environment variable (**must be set by you**).
- `--travis-job-id`: travis-ci job id, defaults to `TRAVIS_JOB_ID` environment variable (set by travis-ci).

### Flags
- `--verbose`: Toggle verbose output to stdout.
