class AddIndexToUsersEmail < ActiveRecord::Migration
	#add index to email column of the users table
  	def change
  		add_index :users, :email, unique:true
  	end
end
