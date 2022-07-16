# frozen_string_literal: true

# ApplicationRecord is the base class for all Active Record models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
