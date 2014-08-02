class User < ActiveRecord::Base
	#ensures all email are lower case before saving
	before_save {self.email = email.downcase}

	#ensures that the name is not blank and has a max of 50 characters
	validates :name, presence: true, length: {maximum: 50}

	#ensures email can only end with .edu Email is NOT case_sensitive, so foo@example.com is the same as FOO@EXAMPLE.COM
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.(edu)+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

	has_secure_password

	#password must have at least six characters
	validates :password, length: {minimum: 6}
end
