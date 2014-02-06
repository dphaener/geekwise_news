require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    login_as(@user)
  end
  
  context "GET #new" do
    setup do
      get :new
    end

    should respond_with(200)
    should render_template "new"
  end

  context "POST #create" do
    context "with invalid data" do
      setup do
        @post = Fabricate.attributes_for(:post, user_id: @user.id, url: "www")
      end

      should "not save the record" do
        assert_no_difference("Post.count") do
          post :create, post: @post
        end
      end
    end

    context "with valid data" do
      setup do
        @post = Fabricate.attributes_for(:post, user_id: @user.id)
      end

      should "save the record" do
        assert_difference("Post.count") do
          post :create, post: @post
        end
        assert_redirected_to home_url
      end
    end
  end

  context "GET #upvote" do
    setup do
      @post = Fabricate(:post, user_id: @user.id)
      login_as(@user)
    end

    should "add a vote and increase the point count for that post" do
      assert_difference("Vote.count") do
        get :upvote, id: @post.id
      end

      @post.reload
      assert_equal 1, @post.points
      assert_redirected_to home_url
    end
  end

  context "GET #downvote" do
    setup do
      @post = Fabricate(:post, user_id: @user.id)
      login_as(@user)
    end

    should "add a vote and decrease the point count for that post" do
      assert_difference("Vote.count") do
        get :downvote, id: @post.id
      end

      @post.reload
      assert_equal -1, @post.points
      assert_redirected_to home_url
    end
  end
end
