require 'spec_helper'

describe "StaticPages" do

	#the subject of the follow tests are within this page
	subject {page}
	let(:base_title) {"College Fudge -"}

	describe "Home Page" do

		#before running any tests, visit the root path first.
		before {visit root_path}

		it {should have_content("College Fudge")}
		it {should have_title("#{base_title} Welcome")}
	end

	describe "About page" do

		before {visit about_path}

		it {should have_content("About")}
		it {should have_title("#{base_title} About")}
	end

	describe "Contact page" do

		before {visit contact_path}

		it {should have_content("Contact")}
		it {should have_title("#{base_title} Contact")}
	end

	describe "FAQ page" do

		before {visit faq_path}

		it {should have_content("FAQ")}
		it {should have_title("#{base_title} FAQ")}
	end

end
