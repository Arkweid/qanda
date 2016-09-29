class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]
  #after_action :publish_comment, only: [:create]

  respond_to :js, :json

  def create
    @comment = @commentable.comments.create(comment_params)
    respond_with @comment
  end

  def update
    respond_with(@comment.update(comment_params)) if current_user.author_of?(@comment)
  end

  def destroy  
    respond_with(@comment.destroy) if current_user.author_of?(@comment)
  end

  private

  def load_commentable
    @commentable = commentable_type.classify.constantize.find(params["#{commentable_type}_id"])
  end

  def commentable_type
    params[:commentable_type]
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user: current_user)
  end

  def publish_comment
    PrivatePub.publish_to("/questions/#{ question_id(@comment.commentable) }/comments", comment: @comment.to_json) if @comment.valid?
  end  
end
