# coding: utf-8
class ReservationFormDisableLottery < ReservationForm
  include ActiveAttr::Model
  include ActiveModel::Associations

  def [](attr)
    self.send(attr)
  end

  def []=(attr, value)
    self.send("#{attr}=", value)
  end

  attr_reader :ticket_ids

  has_many :tickets

  validates :ticket_ids, length: { minimum: 1, maximum: 4 }
  validate :validate_ticket_ids
  def validate_ticket_ids
    unless self.ticket_ids == self.ticket_ids.uniq.compact
      error[:tickets] = 'チケットが重複しているか,不正な入力です'
    end
    unless self.ticket_ids.all? { |t| t.grade == self.grade }
      error[:tickets] = 'チケットと席グレードが一致していません'
    end
  end
end
