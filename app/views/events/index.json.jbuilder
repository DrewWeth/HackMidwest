json.array!(@events) do |event|
  json.extract! event, :id, :name, :desc, :start, :duration, :location, :is_public
  json.url event_url(event, format: :json)
end
