require 'test_helper'

class HomeControllerTest < ActionController::TestCase
 
  context "GET #index" do
    setup do
      @user = Fabricate(:user)
      @post = Fabricate(:post, user_id: @user.id)
      get :index
    end

    should respond_with(200)
    should render_template("index")
    should "assign posts" do
      assert assigns(:posts)
    end
  end
end
