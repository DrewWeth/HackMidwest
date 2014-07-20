json.array!(@alerts) do |alert|
  json.extract! alert, :id, :event_id, :send_datetime, :is_sent
  json.url alert_url(alert, format: :json)
end
