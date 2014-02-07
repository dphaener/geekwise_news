class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post, only: [:upvote, :downvote, :show]

  def new
    @post = Post.new
  end

  def show
    @comment = Comment.new
  end

  def create
    if current_user.posts.create(post_params)
      redirect_to home_url, notice: 'Post was successfully created.'
    else
      render 'new' 
    end
  end

  def upvote
    @post.cast_vote(1, current_user.id)
    @post.save
    if params[:redirect] == "comments"
      redirect_to post_url(@post.id)
    else
      redirect_to home_url
    end
  end

  def downvote
    @post.cast_vote(-1, current_user.id)
    @post.save
    if params[:redirect] == "comments"
      redirect_to post_url(@post.id)
    else
      redirect_to home_url
    end
  end

private

    def set_post
      @post = Post.find(params[:id])  
    end

    def post_params
      params.require(:post).permit(:title, :url, :user_id, :points)
    end
end
