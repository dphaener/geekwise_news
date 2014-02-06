class PostsController < ApplicationController

  before_action :set_post, only: [:upvote, :downvote]

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
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
    redirect_to home_url
  end

  def downvote
    @post.cast_vote(-1, current_user.id)
    @post.save
    redirect_to home_url
  end

private

    def set_post
      @post = Post.find(params[:id])  
    end

    def post_params
      params.require(:post).permit(:title, :url, :user_id, :points)
    end
end
