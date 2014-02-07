class HomeController < ApplicationController

  def index
    Post.calculate_ranking
    @posts = Post.order("rank DESC").page(params[:page]).per(10)
  end
  
end
