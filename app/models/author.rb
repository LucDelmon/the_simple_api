# frozen_string_literal: true

class Author < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }

  has_many :books, dependent: :destroy
end
