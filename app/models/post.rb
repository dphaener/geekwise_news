class Post < ActiveRecord::Base

  has_many :votes
  has_many :comments

  belongs_to :user

  URL_REGEX = /\A(http:\/\/)\S+(com|net|org)\z/

  validates :url, format: URL_REGEX
  validates :title, length: 2..80

  default_scope { order("created_at DESC") }
  
  before_save :no_nil_points

  def cast_vote(points, user_id)
    Vote.create(post_id: self.id, user_id: user_id, voted: true)
    self.points += points
  end

private

  def no_nil_points
    self.points ||= 0 
  end
end
