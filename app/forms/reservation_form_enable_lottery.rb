# coding: utf-8
class ReservationFormEnableLottery < ReservationForm
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Associations

  def [](attr)
    self.send(attr)
  end

  def []=(attr, value)
    self.send("#{attr}=", value)
  end

  attribute :volume, :type => Integer

  validates :volume, numericality: { only_integer: true, greater_than: 0 }
end
