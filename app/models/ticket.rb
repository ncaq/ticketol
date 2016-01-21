class Ticket < ActiveRecord::Base
  belongs_to :grade
  belongs_to :reservation

  scope :inventory, -> { where(reservation_id: nil).order(:id) }
end
