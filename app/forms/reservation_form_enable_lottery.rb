# coding: utf-8
class ReservationFormEnableLottery < ReservationForm
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Associations

  attribute :grade_id, :type => Integer
  attribute :volume, :type => Integer

  validates :volume, numericality: { only_integer: true, greater_than: 0 }
end
