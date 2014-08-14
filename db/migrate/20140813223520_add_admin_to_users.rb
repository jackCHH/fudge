class AddAdminToUsers < ActiveRecord::Migration
  def change
  	# added the default:false, so users will not be admin by default
    add_column :users, :admin, :boolean, default: false
  end
end
