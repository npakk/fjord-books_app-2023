class Reports::CommentsController < CommentsController
  before_action :set_commentable, only: %i[ create edit update destroy ]
  private
    def set_commentable
      @commentable = Report.find(params[:report_id])
    end
end
