class Event < ActiveRecord::Base
  belongs_to :concert
  has_many :grades
  accepts_nested_attributes_for :grades

  def sell_time?
    now = Time.zone.now
    return self.sell_start <= now && now <= self.sell_end
  end
end
