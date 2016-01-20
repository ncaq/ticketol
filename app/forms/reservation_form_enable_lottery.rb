# coding: utf-8
class ReservationFormEnableLottery
  include ReservationForm

  attribute :volume, :type => Integer

  validates :volume, numericality: { only_integer: true, greater_than: 0 }
end
