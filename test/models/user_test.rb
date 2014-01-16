require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should "not allow a blank username" do
  	user = Fabricate.build(:user, username: nil)
  	assert user.invalid?
  end

  should "not allow special characters in username" do
  	user = Fabricate.build(:user, username: "Batman!")
  	assert user.invalid?
  end

  should "require a unique username" do
  	user = Fabricate(:user) 
  	user2 = Fabricate.build(:user)
  	user2.username = user.username
  	assert user2.invalid?
  end

  should "require a password" do
  	user = Fabricate.build(:user, password: nil)
  	assert user.invalid?
  end

  should "not allow a password less than 6 characters" do
  	user = Fabricate.build(:user, password: "abc")
  	assert user.invalid?
  end

  should "require at least one number in the password" do
  	user = Fabricate.build(:user, password: "abcdef")
  	assert user.invalid?
  end

  should "create a password salt before saving" do
  	user = Fabricate(:user)
  	assert user.password_salt.present?
  end

  should "create a password hash before saving" do
  	user = Fabricate(:user)
  	assert user.password_hash.present?	
  end

  should "authenticate a user" do
  	user = Fabricate(:user)
  	current_user = User.authenticate(user.username, user.password)
  	assert current_user.present?
  end

  should "not authenticate a user that doesn't exist" do
  	user = Fabricate(:user)
  	current_user = User.authenticate("barney", "rubble")
  	assert current_user.blank?
  end

end
