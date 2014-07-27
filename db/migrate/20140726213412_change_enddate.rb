class ChangeEnddate < ActiveRecord::Migration
  def change
  	change_column :events, :end, :float
  end
end
