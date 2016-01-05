# coding: utf-8
class Event < ActiveRecord::Base
  belongs_to :concert
  has_many :grades
  accepts_nested_attributes_for :grades

  validate :check_sell_date

  def check_sell_date
    unless sell_start < sell_end && sell_end < date
      em = '販売開始日時 < 販売終了日時 < 公演日時になっていません.'
      errors[:date]       << em
      errors[:sell_start] << em
      errors[:sell_end]   << em
    end
  end

  def sell_ok?
    return sell_time? && self.grades.any? {|g| g.tickets.where(reservation_id: nil).exists? }
  end

  def sell_end?
    return sell_end < Time.zone.now
  end

  def sell_time?
    now = Time.zone.now
    return sell_start <= now && now <= sell_end
  end

  after_create :set_lottery_job

  def set_lottery_job
    if self.lottery
      LotteryJob.set(wait_until: self.sell_end).perform_later(self)
    end
  end
end
