json.array!(@grades) do |grade|
  json.extract! grade, :id, :event_id, :name, :price
  json.url grade_url(grade, format: :json)
end
