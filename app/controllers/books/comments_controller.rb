class Books::CommentsController < CommentsController
  before_action :set_commentable, only: %i[ create edit update destroy ]
  private
    def set_commentable
      @commentable = Book.find(params[:book_id])
    end
end
