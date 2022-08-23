# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken do
  describe '.encode' do
    before do
      allow(JWT).to receive(:encode).and_return('token')
    end

    it 'encodes a payload with rails secret key and return the result' do
      payload = { user_id: 1, exp: 24.hours.from_now.to_i }
      expect(described_class.encode(payload)).to eq('token')
      expect(JWT).to have_received(:encode).with(payload, Rails.application.secrets.secret_key_base.to_s)
    end
  end

  describe '.decode' do
    let(:method_call) { described_class.decode('token') }

    before do
      allow(JWT).to receive(:decode).and_return([{ 'user_id' => 1, 'exp' => 1_661_261_266 }, { 'alg' => 'HS256' }])
    end

    it 'decode the provided token using rails secret key and return the main info in an indifferent access hash' do
      expect(method_call).to eq(HashWithIndifferentAccess.new({ 'user_id' => 1, 'exp' => 1_661_261_266 }))
      expect(JWT).to have_received(:decode).with('token', Rails.application.secrets.secret_key_base.to_s)
    end
  end
end
