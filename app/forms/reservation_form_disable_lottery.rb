# coding: utf-8
class ReservationFormDisableLottery < ReservationForm
  include ActiveAttr::Model

  attribute :tickets_id

  validates :tickets_id, length: { minimum: 1, maximum: 4 }
end
