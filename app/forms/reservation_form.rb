# coding: utf-8
class ReservationForm
  include Virtus.model
  include ActiveModel::Model

  attribute :user_id,        Integer
  attribute :grade_id,       Integer
  attribute :volume,         Integer
  attribute :tickets_id,     Array[Integer]
  attribute :payment_method, Integer

  validates :payment_method, numericality: { only_integer: true }, inclusion: { in: Reservation.payment_methods.values }

  with_options if: :lottery? do |reservation_form|
    validates :tickets_id, absence: true
    validates :volume, numericality: { only_integer: true, greater_than: 0 }
  end
  with_options unless: :lottery? do |reservation_form|
    validates :volume, absence: true
    validates :tickets_id, length: { minimum: 1, maximum: 4 }
  end

  def save
    form.valid?
    Reservation.create!(self)
  end

  private

  def lottery?
    reservation.grade.event.lottery?
  end
end
