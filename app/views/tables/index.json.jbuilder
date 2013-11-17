json.array!(@tables) do |table|
  json.extract! table, 
  json.url table_url(table, format: :json)
end
