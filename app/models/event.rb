# coding: utf-8
class Event < ActiveRecord::Base
  belongs_to :concert
  has_many :grades, :dependent => :destroy
  accepts_nested_attributes_for :grades

  def sell_ok?
    self.sell_time? && self.grades.any?{ |g| g.tickets.inventory.exists? }
  end

  def sell_time?
    self.sell_start? && !self.sell_end?
  end

  def sell_start?
    self.sell_start < Time.zone.now
  end

  def sell_end?
    self.sell_end < Time.zone.now
  end

  def grade_ticket
    self.grades.map{ |g| {grade_id: g.id, tickets: g.tickets.inventory.map{ |t| [t.seat, t.id]}}}
  end

  after_create :set_lottery_job

  def set_lottery_job
    if self.lottery
      LotteryJob.set(wait_until: self.sell_end).perform_later(self)
    end
  end
end
