# coding: utf-8
class ReservationFormEnableLottery
  include ReservationForm

  attribute :volume, :type => Integer

  validates :volume, numericality: { only_integer: true, greater_than: 0 }

  validate :validate_enable_lottery
  def validate_enable_lottery
    unless self.grade.event.lottery
      errors[:grade_id] = '購入対象が不正です'
    end
  end
end
