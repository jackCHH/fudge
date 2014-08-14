class UsersController < ApplicationController
    #call the signed_in_user and correct_user method before calling the corresponding RESTful actions
    before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user,     only: :destroy

    def index
        #make sure it's plural!!! *The code below is for index without pagination
        #@users = User.all

        #with pagination
        @users = User.paginate(page: params[:page])
    end

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
  			sign_in @user
  			flash[:success] = "Welcome!"
  			#redirect to the user profile page
  			redirect_to @user
  		else
  			#render a new form for the user to try if they fail the first form
  			render "new"
  		end
  	end

    def edit
        #since correct_user checks for the parameters, we can omit this method entirely here for now
    end

    def update
        # @user = User.find(params[:id])  <-- no longer need this line because of the correct_user method below

        # uses strong parameters to handle update
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render "edit"
        end
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
    end

  	private
  		#only user objects with the following attributes are allowed.
  		def user_params
  			params.require(:user).permit(:name, :email, :password, :password_confirmation)
  		end

        # Before filters
        #-----------------------------------------------------------

        # redirect to the signin url unless user is already signed in
        def signed_in_user
            unless signed_in?
                store_location
                redirect_to signin_url, notice: "Please sign in."
            end
        end

        def correct_user
            @user = User.find(params[:id])
            #the current_user method is defined in session helper
            redirect_to(root_url) unless current_user?(@user)
        end

        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end
end
