json.array!(@events) do |event|
  json.extract! event, :id, :name, :desc, :start, :end, :location, :is_public
  json.url event_url(event, format: :json)
end
