class CommentsController < ApplicationController
  
  before_action :authenticate_user!, except: [:show]
  before_action :set_comment, only: [:commentup, :commentdown]

  def create
    if comment = current_user.comments.create(comment_params)
      redirect_to post_url(comment.post_id)
    else
      render 'show'  
    end
  end

  def commentup
    @comment.cast_vote(1, current_user.id)
    @comment.save
    redirect_to post_url(@comment.post_id)
  end

  def commentdown
    @comment.cast_vote(-1, current_user.id)
    @comment.save
    redirect_to post_url(@comment.post_id)
  end

private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
