require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    @post = Fabricate(:post, user_id: @user.id)
  end

  context "POST #create" do
    setup do
      @comment = Fabricate.attributes_for(:comment, post_id: @post.id, user_id: @user.id)
    end

    context "if user is not logged in" do
      setup do
        post :create, id: @post.id, comment: @comment
      end

      should "redirect to login page" do
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      setup do
        login_as(@user)
      end

      should "create a new comment" do
        assert_difference("Comment.count") do
          post :create, id: @post.id, comment: @comment
        end
        assert_redirected_to post_url(@post.id)
      end
    end
  end

  context "GET #commentup" do
    setup do
      @comment = Fabricate(:comment, user_id: @user.id, post_id: @post.id)
    end

    context "if user is not logged in" do
      should "redirect to login page" do
        get :commentup, id: @comment.id
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      setup do
        login_as(@user)
      end

      should "add a vote and increase the point count for that post" do
        assert_difference("CommentVote.count") do
          get :commentup, id: @comment.id
        end

        @comment.reload
        assert_equal 1, @comment.points
        assert_redirected_to post_url(@post.id)
      end
    end
  end

  context "GET #commentdown" do
    setup do
      @comment = Fabricate(:comment, user_id: @user.id, post_id: @post.id)
    end

    context "if user is not logged in" do
      should "redirect to login page" do
        get :commentdown, id: @comment.id
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      setup do
        login_as(@user)
      end

      should "add a vote and decrease the point count for that post" do
        assert_difference("CommentVote.count") do
          get :commentdown, id: @comment.id
        end

        @comment.reload
        assert_equal -1, @comment.points
        assert_redirected_to post_url(@post.id)
      end
    end
  end
end
