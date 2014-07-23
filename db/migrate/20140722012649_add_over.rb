class AddOver < ActiveRecord::Migration
  def change
  	add_column :events, :over, :boolean, default: false
  end
end
