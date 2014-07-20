class AlertsEventStart < ActiveRecord::Migration
  def change
  	add_column :alerts, :is_event_start, :boolean
  end
end
