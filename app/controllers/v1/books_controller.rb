module V1
  class BooksController < ApplicationController
    MAX_PAGINATION_LIMIT = 100
    def index
      books = Book.limit(limit(MAX_PAGINATION_LIMIT)).offset(params[:offset])
      render json: BooksRepresenter.new(books).as_json
    end

    def create
      UpdateSkuJob.perform_later(book_params[:title])
      if Author.find_by(first_name: author_params[:first_name])
        author = Author.find_by(first_name: author_params[:first_name])
      else
        author = Author.create!(author_params)
      end
      book = Book.new(book_params.merge(author_id: author.id))
      if book.save
        render json: BookRepresenter.new(book).as_json, status: :created
      else
        render json: book.errors, status: :unprocessable_entity
      end
    end

    def destroy
      book = Book.find(params[:id]).destroy!
      head :no_content
    end

    private
    def book_params
      params.require(:book).permit(:title)
    end

    private
    def author_params
      params.require(:author).permit(:first_name, :last_name, :age)
    end
  end
end
