# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/books', type: :request do
  let(:valid_attributes) do
    {
      title: 'Book Title',
      page_count: 100,
      author_id: Author.create!(name: 'Jean').id,
    }
  end

  let(:invalid_attributes) do
    {
      title: 'Book Title',
      page_count: 0,
    }
  end
  let(:valid_book) do
    Book.create!(valid_attributes)
  end

  describe 'GET /index' do
    let(:request_type) { :get }
    let(:request_url) { books_url }

    before { valid_book }

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
    let(:request_url) { book_url(valid_book) }

    before { valid_book }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      it 'renders a successful response' do
        request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq valid_book.id
      end
    end
  end

  describe 'POST /create' do
    let(:request_type) { :post }
    let(:request_url) { books_url }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      context 'with valid parameters' do
        before { @params = valid_attributes }

        it 'creates a new book' do
          expect { request }.to change(Book, :count).by(1)
        end

        it 'renders a JSON response with the new book' do
          request
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(JSON.parse(response.body)['title']).to eq 'Book Title'
        end
      end

      context 'with invalid parameters' do
        before { @params = invalid_attributes }

        it 'does not create a new book' do
          expect { request }.not_to change(Book, :count)
        end

        it 'renders a JSON response with errors for the new book' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end

  describe 'PATCH /update' do
    let(:request_type) { :patch }
    let(:request_url) { book_url(valid_book) }

    before { valid_book }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      context 'with valid parameters' do
        before { @params = { page_count: 36 } }

        it 'updates the requested listing' do
          expect do
            request
            valid_book.reload
          end.to change(valid_book, :page_count).from(100).to(36)
        end

        it 'renders a JSON response with the listing' do
          request
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(JSON.parse(response.body)['id']).to eq valid_book.id
        end
      end

      context 'with invalid parameters' do
        before { @params = { page_count: 0 } }

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
    let(:request_url) { book_url(valid_book.id) }

    before { valid_book }

    it_behaves_like 'a request that require authentication'

    context 'when authenticated', :with_authenticated_headers do
      it 'destroys the requested listing' do
        expect { request }.to change(Book, :count).by(-1)
        expect { valid_book.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
