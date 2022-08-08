# frozen_string_literal: true

namespace :nginx do
  desc 'reload nginx'
  task :reload do
    on roles(:all) do
      execute 'sudo /usr/sbin/service nginx reload'
    end
  end
end
