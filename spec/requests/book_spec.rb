require 'rails_helper'

describe 'Books API', type: :request do
    let!(:author) {FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 120)}    

    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: '1984', author: author)
            FactoryBot.create(:book, title: 'Animal Farm', author: author)
        end
        it 'return all books' do    
            get '/v1/books'
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
        
        end
        it 'return a subset of books based on limit' do
            get '/v1/books', params: {limit: 1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> 1,
                        'title'=> '1984',
                        'author_name' => 'George Orwell',
                        'author_age' => 120
                    }
                ]
            )
        end
        it 'return all books based on limit and offset' do
            get '/v1/books', params: {limit: 1, offset: 1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> 2,
                        'title'=> 'Animal Farm',
                        'author_name' => 'George Orwell',
                        'author_age' => 120
                    }
                ]    
            )
        end
    end

    describe 'POST /books' do
        it 'create a new book' do
            expect{
                post '/v1/books', params: {book: {title: 'The Martian'},
                author: {first_name: 'Andy', last_name:'Weir', age: 49}
            }
            }.to change { Book.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(2)
            expect(response_body).to eq(
                {
                    'id'=> 1,
                    'title'=> 'The Martian',
                    'author_name' => 'Andy Weir',
                    'author_age' => 49
                }
            )
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) {FactoryBot.create(:book, title: '1984', author: author)}
        it 'deletes a book' do
            expect{
                delete "/v1/books/#{book.id}"
            }.to change {Book.count }.from(1).to(0)
            expect(response).to have_http_status(:no_content)
        end
    end
end