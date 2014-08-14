require 'spec_helper'

describe "User Pages" do

	subject {page}

	let(:base_title) {"College Fudge -"}

	describe "index" do

		let(:user) {FactoryGirl.create(:user)}

		before do
			sign_in user
			visit users_path
		end

		it {should have_title("All users")}
		it {should have_content("All users")}

		describe "pagination" do
			before(:all) {30.times{FactoryGirl.create(:user)}}
			after(:all) {User.delete_all}

			it {should have_selector("div.pagination")}

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector("li", text:user.name)
				end
			end
		end

		describe "delete links" do
			it {should_not have_link("delete")}

			describe "as an admin user" do
				#create an admin user
				let(:admin) {FactoryGirl.create(:admin)}

				#sign in as the admin user
				before do
					sign_in admin
					visit users_path
				end

				# the user_path should have delete links next to each users
				it {should have_link("delete", href: user_path(User.first))}

				# attempt to delete another user
				it "should be able to delete another user" do
					expect do
						click_link("delete", match: :first)
					end.to change(User, :count).by(-1)
				end

				#admin user should not have a delete link
				it {should_not have_link("delete", href: user_path(admin))}
			end
		end
	end

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

			describe "after saving the user" do
				before {click_button submit}
				let(:user) {User.find_by(email: "user@example.edu")}

				it {should have_link("Sign out")}
				it {should have_title(user.name)}
				it {should have_selector("div.alert.alert-success", text: "Welcome!")}
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

	describe "edit" do
		let(:user) {FactoryGirl.create(:user)}

		before do
			# the sign_in is required for the signout link to pass
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it {should have_content("Update your profile")}
			it {should have_title("Edit user")}
		end

		describe "with invalid information" do
			before {click_button "Save changes"}

			it{should have_content("error")}
		end

		describe "with valid information" do
			let(:new_name)  {"New Name"}
			let(:new_email) {"new@example.edu"}

			before do
				fill_in "Name",				with: new_name
				fill_in "Email", 			with: new_email
				fill_in "Password", 		with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it {should have_title(new_name)}
			it {should have_selector("div.alert.alert-success")}
			it {should have_link("Sign out", href: signout_path)}

			#reloads the user variable from the test database using reload and then verifies they are the same within db
			specify {expect(user.reload.name).to eq new_name}
			specify {expect(user.reload.email).to eq new_email}
		end
	end
end
