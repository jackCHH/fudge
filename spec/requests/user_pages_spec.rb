require 'spec_helper'

describe "User Pages" do

	subject {page}
	let(:base_title) {"College Fudge -"}

	describe "signup page" do
		before {visit signup_path}

		it {should have_content("Sign Up")}
		it {should have_title("#{base_title} Sign Up")}
	end

	# describe the sign up action. NOT THE PAGE
	describe "signup" do
		before {visit signup_path}

		#let the submit variable be the create action
		#need to match EXACTLY as the create button on new.html.erb
		let(:submit) {"Create my account"}

		#describe action with invalid information
		describe "with invalid information" do
			it "should not create a user" do
				#after clicking the submit button, expect the count variable not not change because there are no new users
				expect {click_button submit}.not_to change(User, :count)
			end
		end

		#describe with valid information
		describe "with valid information" do
			# before doing anything, fill in the blanks
			before do
				fill_in "Name", 		with: "Example User"
				fill_in "Email",		with: "user@example.edu"
				fill_in "Password", 	with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			#expect the count to increase by one
			it "should create a user" do
				expect {click_button submit}.to change(User, :count).by(1)
			end
		end
	end

	describe "profile page" do
		#Let FactoryGirl create a user object
		let(:user) {FactoryGirl.create(:user)}
		#this path is taken from rails route. More information visit http://www.railstutorial.org/book/sign_up#code-users_resource
		before {visit user_path(user)}

		it {should have_title("#{base_title} #{user.name}")}
		it {should have_content(user.name)}
	end
end
