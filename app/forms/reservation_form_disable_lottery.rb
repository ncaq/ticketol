# coding: utf-8
class ReservationFormDisableLottery < ReservationForm
  include ActiveAttr::Model
  include ActiveModel::Associations

  attr_reader :ticket_ids
  has_many :tickets
  validates :ticket_ids, length: { minimum: 1, maximum: 4 }

  def [](attr)
    self.send(attr)
  end

  def []=(attr, value)
    self.send("#{attr}=", value)
  end
end
