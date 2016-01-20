# coding: utf-8
class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :grade
  enum buy_state: [:default, :lottery_pending, :win, :lose]
  enum payment_method: [:convenience, :credit]
  has_many :tickets

  def from_form(form)
    if form.instance_of?(ReservationFormEnableLottery)
      enable_lottery(form)
    else
      disable_lottery(form)
    end
  end

  def disable_lottery(form)
    ActiveRecord::Base.transaction {
      self.user = form.user
      self.grade = form.grade
      self.payment_method = form.payment_method
      self.convenience_password = SecureRandom.hex(5)
      self.save!

      try_buy_tickets = Ticket.where(id: form.ticket_ids)
      success_buy_tickets_length = Ticket.where(id: form.ticket_ids, reservation_id: nil).
                                   update_all(:reservation_id => self.id)

      unless try_buy_tickets.length == success_buy_tickets_length
        raise ActiveRecord::Rollback
      else
        self.win!
        self.save!
        return true
      end
    }
  end
end
