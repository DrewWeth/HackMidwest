class UserPhonenum < ActiveRecord::Migration
  def change
  	add_column :users, :phone_num, :string
  end
end
