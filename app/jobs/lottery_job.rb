# coding: utf-8
class LotteryJob < ActiveJob::Base
  queue_as :default

  def perform((event))
    grades = event.grades
    grades.each { |grade|
      while true
        open_tickets = grade.tickets.where(reservation_id: nil)
        pendings = grade.lottery_pendings
        if open_tickets.empty? || pendings.empty?
          break
        end
        elected_reservation = pendings.sample.reservation
        elected_lottery_pendings = elected_reservation.lottery_pendings # 連番
        if elected_lottery_pendings.length <= open_tickets.length
          elected_reservation.buy(open_tickets.take(10).map(&:id))
        elsif open_tickets.length < pendings.group(:reservation_id).count.values.min
          break
        end
      end
    }
  end
end
