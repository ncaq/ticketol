class LotteryPending < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :grade
end
