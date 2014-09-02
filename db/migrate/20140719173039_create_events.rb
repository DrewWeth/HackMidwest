class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :desc
      t.datetime :start
      t.datetime :duration
      t.string :location
      t.boolean :is_public

      t.timestamps
    end
  end
end
