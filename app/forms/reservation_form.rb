# coding: utf-8
class ReservationForm
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Associations

  attribute :user_id, :type => Integer
  attribute :payment_method, :type => Integer

  validates :payment_method, numericality: { only_integer: true }, inclusion: { in: Reservation.payment_methods.values }

  def save
    form.valid?
    Reservation.create!(self)
  end
end
