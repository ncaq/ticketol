json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :user_id, :payment_method
  json.url reservation_url(reservation, format: :json)
end
