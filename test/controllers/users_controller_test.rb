require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "GET #new" do
    setup do
      get :new
    end

    should render_template 'new'
  end

  context 'POST #create' do
    setup do
      @user = Fabricate.attributes_for(:user)
    end

    context 'with valid input' do
      should 'create a new user and redirect to the home page' do
        assert_difference('User.count') do
          post :create, user: @user
        end
        assert_redirected_to home_url
      end
    end

    context 'with invalid input' do
      setup do
        post :create, user: { password: "foo" }
      end

      should render_template 'new'
    end
  end
  
  context 'POST #update' do
    context "if user is not logged in" do
      setup do
        put :update
      end

      should "redirect to login page" do
        assert_redirected_to new_session_url
      end
    end

    context "if user is logged in" do
      context "and input is valid" do
        setup do
          @user = Fabricate(:user)
          login_as(@user)
          put :update, user: { username: "Scooby" }
        end

        should "redirect to edit user settings page" do
          assert_redirected_to edit_user_url
        end

        should "flash a success notice" do
          assert_not_nil(flash[:notice])
        end

        should "update the record" do
          @user.reload
          assert_equal "Scooby", @user.username
        end
      end

      context "and input is invalid" do
        setup do
          @user = Fabricate(:user)
          login_as(@user)
          put :update, user: { password: "foo" }
        end

        should render_template "edit"
      end
    end
  end
end
