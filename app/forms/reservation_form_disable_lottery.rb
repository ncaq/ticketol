# coding: utf-8
class ReservationFormDisableLottery
  include ReservationForm

  attr_accessor :ticket_ids

  has_many :tickets

  def initialize(attributes = {}, options = {})
    super
    self.ticket_ids = attributes[:tickets_attributes].map{ |t| t[1][:id].to_i }
  end

  validates :ticket_ids, length: { minimum: 1, maximum: 4 }

  validate :validate_ticket_ids
  def validate_ticket_ids
    unless self.ticket_ids == self.ticket_ids.uniq.compact
      error[:tickets] = 'チケットが重複しているか,不正な入力です'
    end
    unless self.tickets.all? { |t| t.grade == self.grade }
      error[:tickets] = 'チケットが席グレードのものではありません'
    end
  end

  validate :validate_disable_lottery
  def validate_disable_lottery
    if self.grade.event.lottery
      error[:base] = '購入対象が不正です'
    end
  end
end
