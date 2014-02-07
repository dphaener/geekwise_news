require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should "not allow a comment of less than 2 characters" do
    comment = Fabricate.build(:comment, content: "a")
    assert comment.invalid?
  end

  should "have a default value set for points" do
    comment = Fabricate.build(:comment, user_id: 1, points: nil, post_id: 1)
    comment.save
    assert_equal 0, comment.points
  end
end
