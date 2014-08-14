#need to manually generate this file for FactoryGirl

#THIS IS THE ORIGINAL. we'll be using the new ones below to make sure each email is unique
# when attempting to create multiply users

#FactoryGirl.define do 
	#by passing :user, we're telling FactoryGirls this is a User model
#	factory :user do
#		name "User One"
#		email "example@example.edu"
#		password "foobar"
#		password_confirmation "foobar"
#	end
#end

FactoryGirl.define do
	factory :user do
		sequence(:name) {|n| "Person #{n}"}
		sequence(:email) {|n| "person_#{n}@example.edu"}
		password "foobar"
		password_confirmation "foobar"

		# with this code, we can now use FactoryGirl.create(:admin) to create an admin user
		factory :admin do
			admin true
		end
	end
end