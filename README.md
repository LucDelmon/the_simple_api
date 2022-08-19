# the simple api

[![GitHub tag](https://img.shields.io/github/tag/LucDelmon/the_simple_api.svg)](https://GitHub.com/LucDelmon/the_simple_api/tags/)
[![GitHub commits](https://badgen.net/github/commits/LucDelmon/the_simple_api)](https://GitHub.com/Naereen/LucDelmon/the_simple_api/commit/)
[![GitHub latest commit](https://badgen.net/github/last-commit/LucDelmon/the_simple_api)](https://GitHub.com/LucDelmon/the_simple_api/commit/)
[![https://ebookfoundation.github.io/free-programming-books/](https://img.shields.io/website?style=flat&logo=www&logoColor=whitesmoke&label=api&down_color=red&down_message=down&up_color=green&up_message=up&url=https%3A%2F%2Flucdelmon.com%2Fapi%2Fbooks)](https://lucdelmon.com/api/books).


`master`


[![master](https://github.com/LucDelmon/the_simple_api/actions/workflows/ci.yml/badge.svg)](https://github.com/LucDelmon/the_simple_api/actions?query=workflow%3Aci)

`develop`

[![develop](https://github.com/LucDelmon/the_simple_api/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/LucDelmon/the_simple_api/actions?query=workflow%3Aci)
# Introduction
The goal of this project is to create the simplest API possible and add on top of it the most complex and complete CI/CD pipeline while applying best practices and add everything that a serious project should have. 

The project is intended to be used as a reference for other projects and as a starting point for my own project.

# Best practises to follow
- A CI is performing static analysis with rubocop, brakeman and bundle-audit, run tests and check coverage. CI must be green for merging and deploying.
- Commits must follow the [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.
- Branch management is done with [git flow](https://levelup.gitconnected.com/introduction-to-git-flow-3ad331d097fa
  ) (don't forget to git push origin --tags)


# Local Installation (development)

## Requirements
- Ruby version 3.0.0
- PostgresSQL with no password required in localhost (see external_files folder for an example of how to setup this)
- Redis installed locally

## Make it work
After cloning
- `./bin/setup`
- `rspec` to launch the tests
- `rails c` to start a console
- `rails s` to start the server

# Server Installation (production)

## Requirements
- Rvm with ruby version 3.0.0. (probably needs to run this `rvm group add rvm $USER; rvm fix-permissions system; rvm fix-permissions user` since rvm is usually total garbage)
- PostgresSQL with a `the_simple_api` user having all access on a `the_simple_api_production` database and using a password.
  - The password must be indicated in a non committed file `config/secrets.yml`.
  - This file must also include a secret_key_base that you can generate with `rails secret`.
    ```yml
    production:
      database_password: <password>
      secret_key_base: <secret_key_base>
    ```
    
- Example of command for db since pgsql is a badly made as rvm: 
  - `sudo -u postgres psql` 
  - `create user the_simple_api with password 'password';`
  - `alter role the_simple_api superuser createrole createdb replication;`
  - `create database the_simple_api_production owner the_simple_api;`


- A `ubuntu` user with write permissions on `/var/www/html` and a public ssh key from which you hold the private key locally.
- A deploy key on the ubuntu user that allow pulling from the github repository.
- Nginx. Two config files are necessary:
  - the_simple_api.conf
  - the_simple_api_maintenance.conf to place in `/etc/nginx/sites-available/`. Templates are in external_files folders.

- Passenger is [installed](https://www.phusionpassenger.com/docs/advanced_guides/install_and_upgrade/nginx/install/oss/focal.html)
- Redis is [installed](https://redis.io/docs/getting-started/installation/install-redis-on-linux/)

## Make it work
- `export production_server_ip="120.120.120.120"`
- `cap production setup` (to copy the secrets.yml file)
- `cap production sidekiq:install` (install sidekiq service on server)
- `cap production deploy` (to deploy master)
