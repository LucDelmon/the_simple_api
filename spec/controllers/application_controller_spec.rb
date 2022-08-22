# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: 'hello' }
    end
  end

  context 'without any authorization in headers' do
    it 'returns an unauthorized response' do
      get(:index)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Nil JSON web token' })
    end
  end

  context 'with an authorization token in headers' do
    before { request.headers['Authorization'] = token }

    context 'when the token is invalid' do
      let(:token) { 'invalid' }

      it 'returns an unauthorized response' do
        get(:index)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Not enough or too many segments' })
      end
    end

    context 'when the token does not match an existing user' do
      let(:token) { JsonWebToken.encode(user_id: '3') }

      it 'returns an unauthorized response' do
        get(:index)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => "Couldn't find User with 'id'=3" })
      end
    end

    context 'when the token match an existing user' do
      let(:user) { User.create!(email: 'e@test.com', password: '123456') }
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      it 'returns an ok response' do
        get(:index)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'hello' })
      end

      context 'when the token is expired' do
        let(:token) { JsonWebToken.encode(user_id: user.id, exp: 1.day.ago.to_i) }

        it 'returns an unauthorized response' do
          get(:index)
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Signature has expired' })
        end
      end
    end
  end
end
