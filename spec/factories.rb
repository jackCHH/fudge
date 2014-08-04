#need to manually generate this file for FactoryGirls

FactoryGirl.define do 
	#by passing :user, we're telling FactoryGirls this is a User model
	factory :user do
		name "User One"
		email "example@example.edu"
		password "foobar"
		password_confirmation "foobar"
	end
end