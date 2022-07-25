# the simple api

# version: 0.1.0

# Introduction
The goal of this project is to create the simplest API possible. But add on top the most complex and complete CI/CD pipeline. Try to apply best practices and add everything that a serious project should have. To be used as a reference.

Before version 1.0.0 I allow myself to rewrite the commit history to make it cleaner.

# Installation

## Required
- Ruby version 3.0.0
- PostgresSQL with no password required in localhost (see external_files folder to setup this)

## Make it work
After cloning
- ./bin/setup
- rspec to launch the tests
- rails c to start a console
- rails s to start the server

# Best practises
- A CI is performing static analysis with rubocop, brakeman and bundle-audit.
- Commits follow the [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.
- Branch management is done with [git flow](https://levelup.gitconnected.com/introduction-to-git-flow-3ad331d097fa
  ) (don't forget to git push origin --tags)
