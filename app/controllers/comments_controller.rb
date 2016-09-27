class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]

  # respond_to :js

  def create
    # respond_with(@comment = @commentable.comments.create(comment_params))
    @comment = @commentable.comments.create(comment_params)
  end

  def update
    if current_user.author_of?(@comment)
      @comment.update(comment_params)
    #    respond_with(@comment)
    else
      flash.now[:error] = 'You cannot change comments written by others!'
    end
  end

  def destroy
    if current_user.author_of?(@comment)
      #      respond_with(@comment.destroy)
      @comment.destroy
    else
      flash.now[:error] = 'You cannot change comments written by others!'
    end
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
end
