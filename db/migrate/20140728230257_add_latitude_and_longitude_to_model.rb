class AddLatitudeAndLongitudeToModel < ActiveRecord::Migration
  def change
    add_column :events, :timezone, :datetime
  end
end
