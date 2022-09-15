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
    
- Example of command for db:
  - `sudo -u postgres psql` 
  - `create user the_simple_api with password 'password';`
  - `create database the_simple_api_production owner the_simple_api;`


- A `ubuntu` user with write permissions on `/var/www/html` and a public ssh key from which you hold the private key locally.
- A deploy key on the `ubuntu` user that allow pulling from the github repository.
- Nginx is [installed](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/). Two config files are necessary:
  - `the_simple_api.conf`
  - `the_simple_api_maintenance.conf` 
  
  to place both in `/etc/nginx/sites-available/`. Templates are available in `external_files` folders.

- Passenger is [installed](https://www.phusionpassenger.com/docs/advanced_guides/install_and_upgrade/nginx/install/oss/focal.html)
- Redis is [installed](https://redis.io/docs/getting-started/installation/install-redis-on-linux/) + `sudo systemctl enable redis-server` + `sudo systemctl start redis-server`

## Make it work
- `export production_server_ip="120.120.120.120"`
- `cap production setup` (to copy the secrets.yml file)
- `cap production sidekiq:install` (install sidekiq service on server)
- `cap production deploy` (to deploy master)

# API
## Requirements
To use the API you need to use a JWT linked to a User. Which means you need to create a user first.

On development you can use the variable env `DISABLE_AUTHENTICATION=true` when launching the server to disable all kind of authentication.

On production I advice to use Postman.
- First post to `/users`.

  | form-data |                |
  |-----------|----------------|
  | email     | valid email    | 
  | password  | valid password |
- Then post to `/auth/login` with the email and password of the user you created (same payload).
- And under the tests tab on Postman while making the POST add this script:
  ```javascript
  const response = pm.response.json();
  pm.environment.set("jwt_token", response.token);
  ```
  (Be sure to have created a postman env)
- Then for every other request you make, you can go to the Authorisation tab, choose type Bearer and write `{{jwt_token}}` in the token field

## Endpoints
### Users
| verb   | Uri        | actions |
|--------|------------|---------|
| GET    | /users     | index   |
| POST   | /users     | create  |
| GET    | /users/:id | show    |
| PATCH  | /users/:id | update  |
| PUT    | /users/:id | update  |
| DELETE | /users/:id | destroy |

#### Create/update
```json
{
    "email": (string following URI::MailTo::EMAIL_REGEXP),
    "password": (string of at least 6 characters)
}
```
### Authors
| verb   | Uri          | actions |
|--------|--------------|---------|
| GET    | /authors     | index   |
| POST   | /authors     | create  |
| GET    | /authors/:id | show    |
| PATCH  | /authors/:id | update  |
| PUT    | /authors/:id | update  |
| DELETE | /authors/:id | destroy |

#### Create/update
```json
{
    "name": (string of at least 3 characters)
}
```
### Books
| verb   | Uri        | actions |
|--------|------------|---------|
| GET    | /books     | index   |
| POST   | /books     | create  |
| GET    | /books/:id | show    |
| PATCH  | /books/:id | update  |
| PUT    | /books/:id | update  |
| DELETE | /books/:id | destroy |

#### Create/update
```json
{
    "title": (string),
    "page_count": (strictly positive integer),
    "author_id": (id of an existing author),
}
```
