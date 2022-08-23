# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST auth/login' do
    let!(:user) { User.create(email: 'jean@gmail.com', password: 'password') }
    let(:request_type) { :post }
    let(:request_url) { auth_login_url }
    let(:freeze_time) { Time.current }

    before do
      allow(JsonWebToken).to receive(:encode).and_return('token')
    end

    context 'with valid params' do
      before { @params = { email: user.email, password: 'password' } }

      it 'authenticates the user and return a jwt token for the user' do
        Timecop.freeze(freeze_time) { request }
        expect(JsonWebToken).to have_received(:encode).with(user_id: user.id, exp: (freeze_time + 24.hours).to_i)
        expect(JSON.parse(response.body)).to eq(
          { 'token' => 'token', 'exp' => (freeze_time + 24.hours).strftime('%m-%d-%Y %H:%M') }
        )
      end
    end

    shared_examples_for 'a request returning unauthorized' do
      it 'returns an unauthorized error' do
        request
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'unauthorized' })
      end
    end

    context 'when user does not exist' do
      before { @params = { email: 'error@gmail.com', password: 'password' } }

      it_behaves_like 'a request returning unauthorized'
    end

    context 'when password is invalid' do
      before { @params = { email: user.email, password: 'error' } }

      it_behaves_like 'a request returning unauthorized'
    end
  end
end
