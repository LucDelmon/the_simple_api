# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) do
    {
      email: 'fred@gmail.com',
      password: 'password',
    }
  end

  let(:invalid_attributes) do
    {
      email: 'fred',
    }
  end

  let(:valid_user) do
    User.create!(valid_attributes)
  end

  describe 'GET /index' do
    let(:request_type) { :get }
    let(:request_url) { users_url }

    before { valid_user }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      it 'renders a successful response' do
        request
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let(:request_type) { :get }
    let(:request_url) { user_url(valid_user) }

    before { valid_user }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      it 'renders a successful response' do
        request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq valid_user.id
      end
    end
  end

  describe 'POST /create' do
    let(:request_type) { :post }
    let(:request_url) { users_url }

    context 'with valid parameters' do
      before { @params = valid_attributes }

      it 'creates a new User' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new User' do
        request
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body)['email']).to eq 'fred@gmail.com'
      end
    end

    context 'with invalid parameters' do
      before { @params = invalid_attributes }

      it 'does not create a new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'renders a JSON response with errors for the new User' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    let(:request_type) { :patch }
    let(:request_url) { user_url(valid_user) }

    before { valid_user }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      context 'with valid parameters' do
        before { @params = { email: 'jean@gmail.com' } }

        it 'updates the requested user' do
          expect do
            request
            valid_user.reload
          end.to change(valid_user, :email).from('fred@gmail.com').to('jean@gmail.com')
        end

        it 'renders a JSON response with the user' do
          request
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(JSON.parse(response.body)['id']).to eq valid_user.id
        end
      end

      context 'with invalid parameters' do
        before { @params = { email: 'd' } }

        it 'renders a JSON response with errors for the listing' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request_type) { :delete }
    let(:request_url) { user_url(valid_user.id) }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      before { valid_user }

      it 'destroys the requested User' do
        expect { request }.to change(User, :count).by(-1)
        expect { valid_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
