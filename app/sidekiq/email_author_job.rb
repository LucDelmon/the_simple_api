# frozen_string_literal: true

# Warn an author that they have been added to the system.
class EmailAuthorJob
  include Sidekiq::Job

  def perform(name)
    # does not actually send email but is present to justify the need of a redis DB and working worker in production
    name
  end
end
