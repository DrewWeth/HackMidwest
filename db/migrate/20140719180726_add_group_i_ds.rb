class AddGroupIDs < ActiveRecord::Migration
  def change

  	add_column :events, :group_id, :int
  	add_column :users, :group_id, :int
  end
end
