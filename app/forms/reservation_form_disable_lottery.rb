# coding: utf-8
class ReservationFormDisableLottery
  include ReservationForm

  attr_accessor :ticket_ids

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
