require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should "not allow a comment of less than 2 characters" do
    comment = Fabricate.build(:comment, content: "a")
    assert comment.invalid?
  end
end
