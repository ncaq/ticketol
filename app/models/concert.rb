class Concert < ActiveRecord::Base
  belongs_to :user

  has_many :events
  accepts_nested_attributes_for :events

  has_one :concert_image
  accepts_nested_attributes_for :concert_image
end
