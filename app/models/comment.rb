class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :comment_votes

  validates :content, length: { minimum: 2 }

  before_save :no_nil_points

  def cast_vote(points, user_id)
    CommentVote.create(comment_id: self.id, user_id: user_id)
    self.points += points
  end

private

  def no_nil_points
    self.points ||= 0 
  end
end
