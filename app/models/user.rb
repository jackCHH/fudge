class User < ActiveRecord::Base
	#ensures all email are lower case before saving
	before_save {self.email = email.downcase}

	# create a cookie token before creating any users
	before_create :create_remember_token

	#ensures that the name is not blank and has a max of 50 characters
	validates :name, presence: true, length: {maximum: 50}

	#ensures email can only end with .edu Email is NOT case_sensitive, so foo@example.com is the same as FOO@EXAMPLE.COM
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.(edu)+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

	has_secure_password

	#password must have at least six characters
	validates :password, length: {minimum: 6}

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	private

    	def create_remember_token
      		self.remember_token = User.digest(User.new_remember_token)
    	end
end
