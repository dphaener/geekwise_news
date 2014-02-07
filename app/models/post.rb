class Post < ActiveRecord::Base

  has_many :votes
  has_many :comments

  belongs_to :user

  URL_REGEX = /\A(http:\/\/|https:\/\/)\S+/

  validates :url, format: URL_REGEX
  validates :title, length: 2..80

  before_save :no_nil_points

  def cast_vote(points, user_id)
    Vote.create(post_id: self.id, user_id: user_id)
    self.points += points
  end

  def self.calculate_ranking
    posts = Post.all
    posts.each do |post|
      hours_elapsed = (DateTime.now.to_i - post.created_at.to_i).to_f / 3600
      post.rank = post.points.to_f / ((hours_elapsed + 2) ** 1.8)
      post.save
    end
  end

private

  def no_nil_points
    self.points ||= 0 
  end
end
