# frozen_string_literal: true

require 'simplecov'
require 'requests/shared_contexts_and_examples'

SimpleCov.start 'rails' do
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
end
require 'database_cleaner/active_record'

RSpec.configure do |config|
  ENV['RAILS_ENV'] ||= 'test'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.include_context 'with an http request', type: :request

  config.before(:each, :with_authenticated_headers, type: :request) do
    @headers = {
      'Authorization' => JsonWebToken.encode(user_id: User.create!(email: 'e@test.com', password: '123456').id),
      'HTTP_ACCEPT' => 'application/json',
    }
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before do
    Sidekiq::Worker.clear_all
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
