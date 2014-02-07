require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  setup do
    @vote = Vote.create(user_id: 1, post_id: 1)
  end

  should "not allow a vote with duplicate user and post ids" do
    new_vote = Vote.new(user_id: 1, post_id: 1)
    assert new_vote.invalid?
  end
end
