class Reservation < ActiveRecord::Base
  belongs_to :user
  enum payment_method: [:convenience, :credit]

  has_many :tickets
  accepts_nested_attributes_for :tickets
end
