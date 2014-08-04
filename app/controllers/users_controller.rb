class UsersController < ApplicationController
  	def new
  		#the form_for in new.html.erb expects an @user object, which we created here
  		@user = User.new
  	end

  	def show
  		#find the user based on id
  		@user = User.find(params[:id])
  	end

  	def create
  		#utilizes strong parameters in creating a new user
  		@user = User.new(user_params)
  		if @user.save
  			flash[:success] = "Welcome!"
  			#redirect to the user profile page
  			redirect_to @user
  		else
  			#render a new form for the user to try if they fail the first form
  			render "new"
  		end
  	end

  	private
  		#only user objects with the following attributes are allowed.
  		def user_params
  			params.require(:user).permit(:name, :email, :password, :password_confirmation)
  		end
end
