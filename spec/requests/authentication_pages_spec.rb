require 'spec_helper'

describe "Authentication" do

	subject {page}

	#describe the index page
	describe "index" do
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name:"Bob", email:"bob@example.edu")
			FactoryGirl.create(:user, name:"Ben", email:"ben@example.edu")
			visit users_path
		end

		it {should have_title("All users")}
		it {should have_content("All users")}

		it "should list each user" do
			User.all.each do |user|
				expect(page).to have_selector("li", text:user.name)
			end
		end
	end

	#describe the sing in page
	describe "signin page" do
		before {visit signin_path}

		it {should have_content("Sign in")}
		it {should have_title("Sign in")}
	end

	#describe the sign in ACTION
	describe "signin" do
		before {visit signin_path}

		#simply click the sign in button, which is invalid
		describe "with invalid information" do
			before {click_button "Sign in"}

			it {should have_title("Sign in")}
			it {should have_selector("div.alert.alert-error")}

			#the ereror messages should not persist for more than one page
			describe "afterwards visit another page" do
				before {click_link "Home"}
				it {should_not have_selector("div.alert.alert-error")}
			end
		end

		describe "with valid information" do
			let(:user) {FactoryGirl.create(:user)}
			before {sign_in user}

			it {should have_title(user.name)}
			it {should have_link("Users", href: users_path)}
			it {should have_link("Profile", href: user_path(user))}
			it {should have_link("Settings", href: edit_user_path(user))}
			it {should have_link("Sign out", href: signout_path)}
			it {should_not have_link("Sign in", href: signin_path)}

			describe "followed by signout" do
				before {click_link "Sign out"}
				it {should have_link("Sign in")}
			end
		end
	end

	#describe the authorization section
	describe "authorization" do

		# for every non-signed in useres...
		describe "for non-signed-in users" do
			#create a new user with FactoryGirl
			let(:user) {FactoryGirl.create(:user)}

			describe "when attempting to visit a protected page" do
				before do
					# 1. visit edut user path. get redirected
					# 2. fill in the log-in information
					# 3. signin.
					# EXPECTED TO BE REDIRECTED TO THE EDIT USER PAGE
					visit edit_user_path(user)
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				# after signing in, expect the page to be redirected to the edit user page
				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title("Edit user")
					end
				end
			end

			describe "in the Users controller" do

				# if the user is not logged in and wnats to visit the edit path,  it will simply be redicted to the signin page
				describe "visiting the edit page" do
					before {visit edit_user_path(user)}
					it {should have_title("Sign in")}
				end

				describe "submitting to the update action" do
					# "patch" the user's edit profile
					# need to issue a direct path request
					before {patch user_path(user)}
					# expect it to be redirected to the signin page
					specify {expect(response).to redirect_to(signin_path)}
				end

				# if a non-signed in user want to visit the user index it will be redirected to sign in
				describe "visiting the user index" do
					before {visit users_path}
					it {should have_title("Sign in")}
				end
			end
		end

		#for users trying to access other people's files
		describe "as wrong user" do
			#create a user, and then create a wrong user with another email
			let(:user) {FactoryGirl.create(:user)}
			let(:wrong_user) {FactoryGirl.create(:user, email:"wrong@example.edu")}

			#sign in the user
			before {sign_in user, no_capybara: true}

			describe "submitting a GET request to the Users#edit action" do
				#get the user edit path for the wrong user, expect the page to redirect to root_url
				before {get edit_user_path(wrong_user)}
				#specify {expect(response.body).not_to match(full_title("Edit user"))}
				specify {expect(response).to redirect_to(root_url)}
			end

			describe "submitting a PATCH request to the Users#update action" do
				# attempt to update the user's profile as an wrong user logged in, expect to redirec tot root url
				before {patch user_path(wrong_user)}
				specify {expect(response).to redirect_to(root_url)}
			end
		end

		describe "as non-admin user" do
			let(:user) {FactoryGirl.create(:user)}
			let(:non_admin) {FactoryGirl.create(:user)}

			before {sign_in non_admin, no_capybara: true}

			describe "submitting a DELETE request to the Users#destroy action" do
				before {delete user_path(user)}
				specify {expect(response).to redirect_to(root_url)}
			end
		end
	end
end
