require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
  end
  
  context "GET #show" do
    setup do
      @post = Fabricate(:post, user_id: @user.id)
      login_as(@user)
      get :show, id: @post.id
    end

    should render_template 'show'
    should respond_with 200
    should "assign post" do
      assert assigns(:post)
    end
  end

  context "GET #new" do
    setup do
      login_as(@user)
      get :new
    end

    should respond_with(200)
    should render_template "new"
  end

  context "POST #create" do
    context "with invalid data" do
      setup do
        login_as(@user)
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
        login_as(@user)
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
    end

    context "if user is not logged in" do
      should "redirect to login page" do
        get :upvote, id: @post.id
        assert_redirected_to new_session_url
      end
    end

    context "user is logged in" do
      setup do
        login_as(@user)
      end

      should "add a vote, increase the point count for that post, and redirect to home url" do
        assert_difference("Vote.count") do
          get :upvote, id: @post.id
        end

        @post.reload
        assert_equal 1, @post.points
        assert_redirected_to home_url
      end

      should "add a vote, increase the point count for that post, and redirect to post#show url" do
        assert_difference("Vote.count") do
          get :upvote, id: @post.id, redirect: "comments"
        end

        @post.reload
        assert_equal 1, @post.points
        assert_redirected_to post_url(@post.id)
      end
    end
  end

  context "GET #downvote" do
    setup do
      @post = Fabricate(:post, user_id: @user.id)
    end

    context "if user is not logged in" do
      should "redirect to login page" do
        get :downvote, id: @post.id
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      setup do
        login_as(@user)
      end

      should "add a vote, decrease the point count for that post, and redirect to the home url" do
        assert_difference("Vote.count") do
          get :downvote, id: @post.id
        end

        @post.reload
        assert_equal -1, @post.points
        assert_redirected_to home_url
      end

      should "add a vote, decrease the point count for that post, and redirect to the post#show url" do
        assert_difference("Vote.count") do
          get :downvote, id: @post.id, redirect: "comments"
        end

        @post.reload
        assert_equal -1, @post.points
        assert_redirected_to post_url(@post.id)
      end
    end
  end
end
