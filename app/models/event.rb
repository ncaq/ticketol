class Event < ActiveRecord::Base
  belongs_to :concert
  has_many :grades
  accepts_nested_attributes_for :grades
end
