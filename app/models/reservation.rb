# coding: utf-8
class Reservation < ActiveRecord::Base
  belongs_to :user
  enum payment_method: [:convenience, :credit]

  has_many :tickets
  accepts_nested_attributes_for :tickets


  def buy(ticketIds)
    if ticketIds != ticketIds.uniq
      em = '同じチケットを注文することはできません'
      self.errors[:base] << em
      raise em
    end

    self.save!
    tryBuyTickets = Ticket.where(id: ticketIds)
    updateSucessLength = Ticket.where(id: ticketIds, reservation_id: nil).
                         update_all(:reservation_id => self.id)

    if tryBuyTickets.length == updateSucessLength
      if self.convenience?
        self.convenience_password = SecureRandom.hex(5)
        self.save!
      end
      self.lottery_pendings.destroy_all
      return true
    else
      em = <<EOS
指定されたチケットを購入することが出来ませんでした.
違うチケットでもう一度お試しください.
EOS
      errors[:base] << em
      raise
    end
  end
end
