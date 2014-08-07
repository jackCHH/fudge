require 'spec_helper'

describe User do
	#before running the following tests, create a new user in this case
	before {@user = User.new(name: "Example User", email: "user@example.edu", password: "foobar", password_confirmation:"foobar")}


	#makes @user the default subject for this test
	subject {@user}

	#tests for the existence for name, email, and password digest
	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:authenticate)}
	# store the sign in session within a cookie
	it {should respond_to(:remember_token)}

	# verifying that @user is initially valid
	it {should be_valid}

	# set the user's name to a blank value, then test to make sure it's not a valid name
	describe "when name is not present" do
		#before doing the test, set the name to blank
		before {@user.name = " "}
		it {should_not be_valid}
	end

	#see "when name is not present" for explanation
	describe "when email is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end

	# if the user's name is over 50 characters it's not valid
	describe "when name is too long" do
		before {@user.name = "a"*51}
		it {should_not be_valid}
	end

	# determines other email format/messed-up formats are invalid
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
            addresses.each do |invalid_address|
            	@user.email = invalid_address
            	expect(@user).not_to be_valid
            end
        end
	end

	#only .edu is valid as an email format
	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.edu user@foo.EDU A_US-ER@f.b.edu]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	#ensures that no two user would have the same email
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			# we don't want the email to be case sensitive, so we make sure the copy cat's email is in uppercase and the original is in lowercase, 
			# so that when  tested, both will appear as the same email address
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it {should_not be_valid}
	end

	#ensure the password must be present
	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email:"user@example.com", password: " ", password_confirmation: " ")
		end

		it {should_not be_valid}
	end

	#ensures password matches the confirmation
	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end

	#password length authentication
	describe "with a password that's too short" do
		before {@user.password = @user.password_confirmation = "a"*5}
		it {should be_invalid}
	end

	#authentication for the return value
	describe "return value of authenticate method" do
		before {@user.save}
		#let the variable found_user be the User found through email
		let(:found_user) {User.find_by(email: @user.email)}

		#test if given a valid password
		describe "with valid password" do
			# @user's password should be the same as found_user's password AFTER AUTHENTICATION
			it {should eq found_user.authenticate(@user.password)}
		end
		#test if given an invalid password
		describe "with invalid password" do
			#let user_for_invalid_password be a variable for an invalid password
			let(:user_for_invalid_password) {found_user.authenticate("invalid password")}

			#@usre should not equal invalid password
			it {should_not eq user_for_invalid_password}
			specify {expect(user_for_invalid_password).to be_false}
		end
	end

	#remember the user token
	describe "remember token" do
		before {@user.save}
		# equivalent to "it { expect(@user.remember_token).not_to be_blank }"
		its(:remember_token) {should_not be_blank}
	end
end
