json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :grade_id, :reservation_id, :seat
  json.url ticket_url(ticket, format: :json)
end
