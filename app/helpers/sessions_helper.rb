module SessionsHelper

	# 1. create the token. 
	# 2. place the newly created token in the browser cookie
	# 3. update the newly "cookied" token as the new user's token
	# 4. set the current user to the given user
	def sign_in(user)
		remember_token = User.new_remember_token
		# cookies.permanent means the token won't expire until 20 years later in rails
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
	end

	# to see if a current user is signed in or not
	def signed_in?
		# signed_in? returns yes of the current_user is NOT nil
		!current_user.nil?
	end

	#current_user=() is the same as self.current_user = 
	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def sign_out
		# change the token in case the account has been compromised
		current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end
end
