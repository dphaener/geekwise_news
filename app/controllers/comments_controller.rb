class CommentsController < ApplicationController
  
  before_action :authenticate_user!, only: [:create]

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def create
    if comment = current_user.comments.create(content: params[:comment][:content], post_id: params[:comment][:post_id])
      redirect_to comment_url(comment.post_id)
    else
      render 'show'  
    end
  end
end
