# frozen_string_literal: true

require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 46) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'H.G', last_name: 'Wels', age: 78) }

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1984', author: first_author)
      FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
    end

    it 'return all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            'id'          => 1,
            'title'       => '1984',
            'author_name' => 'George Orwell',
            'author_age'  => 46
          },
          {
            'id'          => 2,
            'title'       => 'The Time Machine',
            'author_name' => 'H.G Wels',
            'author_age'  => 78
          }
        ]
      )
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: { limit: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id'          => 1,
            'title'       => '1984',
            'author_name' => 'George Orwell',
            'author_age'  => 46
          }
        ]
      )
    end

    it 'returns a subset of books based on limit and offset' do
      get '/api/v1/books', params: { limit: 1, offset: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id'          => 2,
            'title'       => 'The Time Machine',
            'author_name' => 'H.G Wels',
            'author_age'  => 78
          }
        ]
      )
    end
  end

  describe 'POST /books' do
    it 'create a new book' do
      expect do
        post '/api/v1/books', params: {
          book:   { title: 'The Martian' },
          author: { first_name: 'Andy', last_name: 'Weir', age: '48' }
        }
      end.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          'id'          => 1,
          'title'       => 'The Martian',
          'author_name' => 'Andy Weir',
          'author_age'  => 48
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: 1984, author: first_author) }

    it 'deletes a book' do
      expect do
        delete "/api/v1/books/#{book.id}"
      end.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
