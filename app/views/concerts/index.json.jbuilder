json.array!(@concerts) do |concert|
  json.extract! concert, :id, :title, :artist, :user_id
  json.url concert_url(concert, format: :json)
end
