# frozen_string_literal: true

# Basic controller for books
class BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]

  # GET /books
  # @return [JSON, nil]
  def index
    @books = Book.all

    render json: @books
  end

  # GET /books/1
  # @return [JSON, nil]
  def show
    render json: @book
  end

  # POST /books
  # @return [JSON, nil]
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  # @return [JSON, nil]
  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  # @return [JSON, nil]
  def destroy
    @book.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # @return [Book]
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # @return [ActionController::Parameters]
  def book_params
    params.require(:book).permit(:title, :page_count, :author_id)
  end
end
