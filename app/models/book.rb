# frozen_string_literal: true

# Represent a book in the database
class Book < ApplicationRecord
  validates :title, :page_count, presence: true
  validates :page_count, numericality: { greater_than: 0, only_integer: true }

  belongs_to :author
end
