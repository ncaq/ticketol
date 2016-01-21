class Grade < ActiveRecord::Base
  belongs_to :event
  has_many :tickets, :dependent => :destroy
  accepts_nested_attributes_for :tickets
  has_many :reservations
end
