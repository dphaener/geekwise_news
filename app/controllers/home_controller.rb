class HomeController < ApplicationController

  def index
    Post.calculate_ranking
    @posts = Post.order("rank DESC, created_at DESC").page(params[:page]).per(10)
  end
  
end
