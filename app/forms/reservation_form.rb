# coding: utf-8
class ReservationForm
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Associations

  def [](attr)
    self.send(attr)
  end

  def []=(attr, value)
    self.send("#{attr}=", value)
  end

  attr_reader :user_id
  attr_reader :grade_id
  attribute :payment_method, :type => Integer

  belongs_to :user
  belongs_to :grade

  validates :payment_method, numericality: { only_integer: true }, inclusion: { in: Reservation.payment_methods.values }

  def save
    form.valid?
    Reservation.create!(self)
  end
end
