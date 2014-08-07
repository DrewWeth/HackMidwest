class Countrycode < ActiveRecord::Migration
  def change
  	add_column :users, :country, :integer, :default => 1
  	add_column :groups, :user_id, :integer
  	
  end
end
