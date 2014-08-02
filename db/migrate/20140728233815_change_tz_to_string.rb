class ChangeTzToString < ActiveRecord::Migration
  def change
    change_column :events, :timezone, :string

  end
end
