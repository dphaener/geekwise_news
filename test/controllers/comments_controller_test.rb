require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  context "GET #show" do
    setup do
      @user = Fabricate(:user)
      @post = Fabricate(:post, user_id: @user.id)
      get :show, id: @post.id
    end

    should render_template 'show'
    should respond_with 200
    should "assign post" do
      assert assigns(:post)
    end
  end

  context "POST #create" do
    setup do
      @user = Fabricate(:user)
      @post = Fabricate(:post, user_id: @user.id)
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
        assert_redirected_to comment_url(@post.id)
      end
    end
  end
end
