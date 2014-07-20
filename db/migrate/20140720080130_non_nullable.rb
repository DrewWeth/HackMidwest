class NonNullable < ActiveRecord::Migration
  def change
  	change_column :alerts, :is_sent, :boolean, :null => false
  end
end
