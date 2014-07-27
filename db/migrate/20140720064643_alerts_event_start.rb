class AlertsEventStart < ActiveRecord::Migration
  def change
  	add_column :alerts, :is_event_start, :boolean
  	change_column :alerts, :is_sent, :boolean, :default => false
  end
end
