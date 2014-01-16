class User < ActiveRecord::Base

	attr_accessor :password

	before_save :encrypt_password

	validates :username, presence: true, uniqueness: true, format: /\A[\w]+\z/

	validates :password, length: { minimum: 6 }, format: /\d/

	def encrypt_password
		if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
	end

	def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

end
