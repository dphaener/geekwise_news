require 'test_helper'

class CommentVoteTest < ActiveSupport::TestCase
  setup do
    @vote = CommentVote.create(user_id: 1, comment_id: 1)
  end

  should "not allow a vote with duplicate user and comment ids" do
    new_vote = CommentVote.new(user_id: 1, comment_id: 1)
    assert new_vote.invalid?
  end

  should "allow a user to vote on two different comments" do
    new_vote = CommentVote.new(user_id: 1, comment_id: 2)
    assert new_vote.valid?
  end
end
