json.array!(@confirmations) do |confirmation|
  json.extract! confirmation, :id
  json.url confirmation_url(confirmation, format: :json)
end
