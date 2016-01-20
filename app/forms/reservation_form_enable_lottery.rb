# coding: utf-8
class ReservationFormEnableLottery < ReservationForm
  include ActiveModel::Model
  include ActiveAttr::TypecastedAttributes

  attribute :grade_id, :type => Integer
  attribute :volume, :type => Integer

  validates :volume, numericality: { only_integer: true, greater_than: 0 }
end
