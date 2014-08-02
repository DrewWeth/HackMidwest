class GroupConfirm < ActiveRecord::Migration
  def change
  	add_column :groups, :request_string, :string
  	add_column :users, :restriction_level, :integer, default: 0

  end
end
