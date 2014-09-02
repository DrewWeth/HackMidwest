class ChangeEnddate < ActiveRecord::Migration
  def change
  	change_column :events, :duration, :float
  end
end
