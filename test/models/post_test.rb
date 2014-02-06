require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @user = Fabricate(:user)
  end

  should "not allow invalid url" do
    @post = Fabricate.build(:post, url:"www", user_id: @user.id)
    assert @post.invalid?
  end

  should "not allow title less than 2 characters" do
    @post = Fabricate.build(:post, title: "a", user_id: @user.id)
    assert @post.invalid?
  end

  should "not allow a title more than 80 characters" do
    @post = Fabricate.build(:post, title: "a" * 81, user_id: @user.id)
    assert @post.invalid?
  end

  should "have a default value set for points" do
    @post = Fabricate.build(:post, user_id: @user.id, points: nil)
    @post.save
    assert_equal 0, @post.points
  end

  context "#cast_vote" do
    setup do
      @post = Fabricate(:post)
    end

    context "when user has not yet voted on this post" do
      should "create a new vote for the user and post and increase point count" do
        assert_difference("Vote.count") do
          @post.cast_vote(1, @user.id)
        end

        assert_equal 1, @post.points
      end
    end

    context "when user has already cast a vote on this post" do
      setup do
        @post.cast_vote(1, @user.id)
      end

      should "not create another vote record" do
        assert_no_difference("Vote.count") do
          @post.cast_vote(1, @user.id)
        end
      end
    end
  end
end
