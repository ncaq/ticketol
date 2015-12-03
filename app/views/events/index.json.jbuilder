json.array!(@events) do |event|
  json.extract! event, :id, :concert_id, :place, :date, :sell_start, :sell_end, :lottery
  json.url event_url(event, format: :json)
end
