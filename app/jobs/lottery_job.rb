# coding: utf-8
class LotteryJob < ActiveJob::Base
  queue_as :default

  def perform((event))
    ActiveRecord::Base.transaction {
      event.grades.each { |grade|
        inventory = grade.tickets.inventory
        pendings = grade.reservations.lottery_pending
        until inventory.empty? || pendings.empty?
          elected = pendings.sample
          if elected.volume <= inventory.length
            elected.buy(inventory.take(elected.volume).map(&:id))
          else
            elected.lose!
          end
          inventory = grade.tickets.inventory
          pendings = grade.reservations.lottery_pending
        end
      }
    }
  end
end
