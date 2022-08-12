# frozen_string_literal: true

require 'spec_helper'

require File.expand_path('../config/environment', __dir__)

require 'rspec/rails'
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
end

RSpec::Sidekiq.configure do |config|
  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
