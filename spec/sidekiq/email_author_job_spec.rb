# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailAuthorJob, type: :job do
  describe '#perform' do
    it 'just returns the name' do
      expect(described_class.new.perform('Fred')).to eq 'Fred'
    end
  end
end
