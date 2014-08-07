class AddRememeberTokenToUsers < ActiveRecord::Migration
  	def change
  		add_column :users, :remember_token, :string
  		#expect to retrieve users with index, so we add an add_index method
  		add_index :users, :remember_token
  	end
end
