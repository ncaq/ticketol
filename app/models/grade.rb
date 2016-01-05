class Grade < ActiveRecord::Base
  belongs_to :event
  has_many :tickets
  accepts_nested_attributes_for :tickets

  has_many :lottery_pendings
end
