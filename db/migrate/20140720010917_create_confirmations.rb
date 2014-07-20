class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|

      t.timestamps

      t.belongs_to :event

      t.integer :user_id 
      t.integer :event_id 

    end
  end
end
