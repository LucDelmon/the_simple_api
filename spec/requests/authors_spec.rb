# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/authors', type: :request do
  let(:valid_attributes) do
    {
      name: 'Fred',
    }
  end

  let(:invalid_attributes) do
    {
      name: 'f',
    }
  end

  let(:valid_author) do
    Author.create!(valid_attributes)
  end

  describe 'GET /index' do
    let(:request_type) { :get }
    let(:request_url) { authors_url }

    before { valid_author }

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
    let(:request_url) { author_url(valid_author) }

    before { valid_author }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      it 'renders a successful response' do
        request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq valid_author.id
      end
    end
  end

  describe 'POST /create' do
    let(:request_type) { :post }
    let(:request_url) { authors_url }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      context 'with valid parameters' do
        before { @params = valid_attributes }

        it 'creates a new Author' do
          expect { request }.to change(Author, :count).by(1)
        end

        it 'enqueues a job to send an email to the author' do
          request
          expect(EmailAuthorJob).to have_enqueued_sidekiq_job('Fred')
        end

        it 'renders a JSON response with the new Author' do
          request
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(JSON.parse(response.body)['name']).to eq 'Fred'
        end
      end

      context 'with invalid parameters' do
        before { @params = invalid_attributes }

        it 'does not create a new Author' do
          expect { request }.not_to change(Author, :count)
        end

        it 'renders a JSON response with errors for the new Author' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end

  describe 'PATCH /update' do
    let(:request_type) { :patch }
    let(:request_url) { author_url(valid_author) }

    before { valid_author }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      context 'with valid parameters' do
        before { @params = { name: 'Jean' } }

        it 'updates the requested listing' do
          expect do
            request
            valid_author.reload
          end.to change(valid_author, :name).from('Fred').to('Jean')
        end

        it 'renders a JSON response with the listing' do
          request
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(JSON.parse(response.body)['id']).to eq valid_author.id
        end
      end

      context 'with invalid parameters' do
        before { @params = { name: 'd' } }

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
    let(:request_url) { author_url(valid_author.id) }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      before { valid_author }

      it 'destroys the requested listing' do
        expect { request }.to change(Author, :count).by(-1)
        expect { valid_author.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
