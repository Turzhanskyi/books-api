# frozen_string_literal: true

require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    before do
      create_list(:book, 2)
    end

    it 'return all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    let!(:author) { create(:author) }

    it 'create a new book' do
      expect do
        post '/api/v1/books', params: { book: { title: 'book3', author_id: author.id } }
      end.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { create(:book) }

    it 'deletes a book' do
      expect do
        delete "/api/v1/books/#{book.id}"
      end.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
