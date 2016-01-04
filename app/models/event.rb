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

  def sell_time?
    now = Time.zone.now
    return sell_start <= now && now <= sell_end
  end
end
