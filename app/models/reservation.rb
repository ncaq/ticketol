# coding: utf-8
class Reservation < ActiveRecord::Base
  belongs_to :user
  enum payment_method: [:convenience, :credit]

  has_many :tickets
  accepts_nested_attributes_for :tickets

  def lottery(grade_id, volume)
    begin
      if volume == 0
        em = 'チケットを指定してください'
        self.errors[:base] << em
        raise em
      end

      grade = Grade.find(grade_id)
      unless grade
        em = '席グレードが不正です'
        self.errors[:base] << em
        raise em
      end

      lottery_pending = LotteryPending.create! { |l|
        l.grade = grade
        l.reservation = self
      }

      self.save!

    rescue => e
      if self.id
        self.destroy
        lottery_pending.destroy
      end
      errors[:base] << 'エラーが発生したので購入はキャンセルされました'
      puts e
      return false
    end
  end

  def notLottery(tickets_attributes)
    begin
      unless tickets_attributes
        em = 'チケットを指定してください'
        self.errors[:base] << em
        raise em
      end

      ticketsIds = tickets_attributes.to_a.select { |t| not t[1][:_destroy] }.map { |t| t[1][:id] }

      if ticketsIds != ticketsIds.uniq
        em = '同じチケットを注文することはできません'
        self.errors[:base] << em
        raise em
      end

      self.save!
      tryBuyTickets = Ticket.where(id: ticketsIds)
      updateSucessLength = Ticket.where(id: ticketsIds, reservation_id: nil).
                           update_all(:reservation_id => self.id)

      if tryBuyTickets.length == updateSucessLength
        if self.convenience?
          self.convenience_password = SecureRandom.hex(5)
          self.save!
        end
        return true
      else
        em = <<EOS
指定されたチケットを購入することが出来ませんでした.
違うチケットでもう一度お試しください.
EOS
        errors[:base] << em
        raise
      end
    rescue => e
      if self.id
        Ticket.where(reservation_id: self.id).update_all(:reservation_id => nil)
        self.destroy
      end
      errors[:base] << 'エラーが発生したので購入はキャンセルされました'
      puts e
      return false
    end
  end
end
