class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :event_id
      t.datetime :send_datetime
      t.boolean :is_sent

      t.timestamps
    end
  end
end
