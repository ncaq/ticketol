# coding: utf-8
class ReservationFormDisableLottery
  include ReservationForm

  def initialize(attributes = {}, options = {})
    super
    if attributes != {}
      self.ticket_ids = attributes[:tickets_attributes].map{ |t| t[1][:id].to_i }
    end
  end

  def record_save
    if self.valid?
      record = Reservation.new()
      return record.from_form(self) ? record : false
    else
      errors[:base] = '購入できませんでした,もう一度やり直してください'
    end
  end

  attr_accessor :ticket_ids
  has_many :tickets

  validates :ticket_ids, length: { minimum: 1, maximum: 4 }

  validate :validate_ticket_ids
  def validate_ticket_ids
    unless self.ticket_ids == self.ticket_ids.uniq.compact
      errors[:tickets] = 'チケットが重複しているか,不正な入力です'
    end
    unless self.tickets.all? { |t| t.grade == self.grade }
      errors[:tickets] = 'チケットが席グレードのものではありません'
    end
  end

  validate :validate_disable_lottery
  def validate_disable_lottery
    if self.grade.event.lottery
      errors[:grade_id] = '購入対象が不正です'
    end
  end
end
