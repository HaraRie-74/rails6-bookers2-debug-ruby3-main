class BooksController < ApplicationController
  before_action :ensure_correct_user,only:[:edit,:update]

  def show
    @book = Book.find(params[:id])
    @user=User.find(@book.user_id)
    @book_new=Book.new
    @comment=BookComment.new
  end

  def index
    @book_new=Book.new
    # 下３行、一週間分のいいねの多い順番を取得
    to=Time.current.at_end_of_day
    # ↑現在まで
    from=(to-6.day).at_beginning_of_day
    # ↑現在-6(つまり、一週間前)からの期間で
    @books = Book.includes(:favorited_users).sort{|a,b| b.favorited_users.size <=> a.favorited_users.size}
    #もとはBook.allだった。 　　　　　　　　↑sort・・・いいねの多い順に配列を並び替えている　a<=>bは少ない順になるので今回はb<=>a
    @book=Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @book_new=Book.new
      @books=Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

end
