# Agent Guidelines

## Scope

These instructions apply to the entire repository.

## Ruby Environment

- This project uses Ruby 4.0.6, as specified in `.ruby-version`.
- Treat `.ruby-version` as the source of truth if the project's Ruby version changes.
- Use `rbenv` whenever interacting with Ruby, Bundler, Rails, Rake, RuboCop, or other Ruby-based tools.
- Before running Ruby commands, verify that `rbenv version` resolves to the version in `.ruby-version`.
- Prefer commands executed through `rbenv exec`, such as `rbenv exec bundle exec rails test`.
- Do not use gems or executables from RVM, mise, the system Ruby, or another Ruby installation.

## Verification

- Run the relevant tests after making changes.
- Run `rbenv exec bundle exec rubocop` for Ruby style checks.
- Run `rbenv exec bundle exec rails test` for the Rails test suite.
- Use `rbenv exec bundle exec bin/ci` when full repository verification is appropriate.
