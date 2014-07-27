class GroupActiveMemberCount < ActiveRecord::Migration
  def change
	  add_column :groups, :is_active, :boolean, :default => true
	  add_column :groups, :member_count, :integer, :default => 0
 	  add_column :groups, :parent_id, :integer 
  end
end
