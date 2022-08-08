# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

set :application, 'the_simple_api'
set :repo_url, 'git@github.com:LucDelmon/the_simple_api.git'
set :rvm_ruby_version, 'ruby-3.0.0'
set :rvm_custom_path, '/usr/share/rvm'
set :deploy_to, '/var/www/html/the_simple_api'
append :linked_dirs, '.bundle', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle'
set :passenger_rvm_ruby_version, 'ruby-3.0.0'
