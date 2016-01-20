# coding: utf-8
class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :grade
  enum buy_state: [:default, :lottery_pending, :win, :lose]
  enum payment_method: [:convenience, :credit]
  has_many :tickets

  def from_form(form)
    self.user = form.user
    self.grade = form.grade
    self.payment_method = form.payment_method
    self.convenience_password = SecureRandom.hex(5)
    if form.instance_of?(ReservationFormEnableLottery)
      enable_lottery(form)
    else
      disable_lottery(form)
    end
  end

  def enable_lottery(form)
    self.volume = form.volume
    self.lottery_pending!
    self.save!
  end

  def disable_lottery(form)
    self.volume = form.ticket_ids.length
    self.save!
    self.buy(form.ticket_ids)
  end

  def buy(ticket_ids)
    ActiveRecord::Base.transaction {
      try_buy_tickets = Ticket.where(id: ticket_ids)
      success_buy_tickets_length = Ticket.where(id: ticket_ids, reservation_id: nil).
                                   update_all(:reservation_id => self.id)

      if try_buy_tickets.length != success_buy_tickets_length
        raise ActiveRecord::Rollback
      else
        self.win!
        self.save!
      end
    }
  end
end
