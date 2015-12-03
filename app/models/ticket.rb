class Ticket < ActiveRecord::Base
  belongs_to :grade
  belongs_to :reservation
end
