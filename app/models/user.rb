class User < ActiveRecord::Base

  has_many :posts
  has_many :votes
  has_many :comments
  has_many :comment_votes
  
	attr_accessor :password

	before_save :encrypt_password

	validates :username, presence: true, uniqueness: true, format: /\A[\w]+\z/

	validates :password, length: { minimum: 6 }, format: /\d/, :if => :password_validatible?

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
private

  def password_validatible?
    password.present? || new_record?
  end

	def encrypt_password
		if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
	end
end
