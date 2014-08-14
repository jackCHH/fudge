class SessionsController < ApplicationController
	def new
	end

	def create
		#user variable will be determined by the email all lowercase
		user  = User.find_by(email: params[:session][:email].downcase)
		#if the user and it's authenticated password matches, log in
		if user && user.authenticate(params[:session][:password])
			#upon successful signin, log in the user using the sign_in method and redirect to the profile page
			sign_in user
			redirect_back_or user
		else
			#other wise flash error messages. flash.now will ensure it will only flash once
			flash.now[:error] = "Invalid email/password combination"
			render "new"
		end
	end

	def destroy
		#simply call the signout method and then redirect to home page
		sign_out
		redirect_to root_url
	end
end
