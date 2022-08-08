# frozen_string_literal: true

namespace :api do
  desc 'Put the api online'
  task :online do
    on roles(:web) do
      sudo :ln, '-fs', ' /etc/nginx/sites-available/the_simple_api.conf /etc/nginx/sites-enabled/the_simple_api.conf'
    end
  end

  desc 'Put the api into maintenance mode'
  task :offline do
    on roles(:web) do
      sudo :ln, '-fs',
        ' /etc/nginx/sites-available/the_simple_api_maintenance.conf /etc/nginx/sites-enabled/the_simple_api.conf'
    end
  end
end

after 'api:online', 'nginx:reload'
after 'api:offline', 'nginx:reload'
