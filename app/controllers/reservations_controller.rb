class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]
  before_action :set_event, only: [:new, :create]

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    has?
  end

  def new
    if @event.sell_time?
      if current_user
        if current_user.buyer?
          allow
          @reservation = Reservation.new
          @reservation.tickets.build
        else
          deny
        end
      else
        allow
        redirect_to new_user_session_url
      end
    else
      deny
    end
  end

  def create
    if current_user && current_user.buyer? && @event.sell_time?
      allow
      begin
        unless @event.lottery
          @reservation = Reservation.new()
          @reservation.user_id = current_user.id
          @reservation.payment_method = reservation_params[:payment_method]
          ticketsIds = reservation_params[:tickets_attributes].map { |t| t[1][:id] }
          tryBuyTickets = Ticket.where(id: ticketsIds)

          @reservation.save!
          updateSucessLength = Ticket.where(id: ticketsIds, reservation_id: nil).
                               update_all(:reservation_id => @reservation.id)

          respond_to do |format|
            if 0 < tryBuyTickets.length && tryBuyTickets.length == updateSucessLength
              if @reservation.convenience?
                @reservation.convenience_password = SecureRandom.hex(5)
                @reservation.save!
              end
              format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
              format.json { render :show, status: :created, location: @reservation }
            else
              raise
            end
          end
        end
      rescue
        if @reservation.id
          Ticket.where(reservation_id: @reservation.id).update_all(:reservation_id => nil)
          @reservation.destroy
        end
        format.html {
          params[:event][:id] = @event.id
          render :new
        }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    else
      deny
    end
  end

  def destroy
    has?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_event
    event_id = params[:event_id] || params[:event][:id]
    @event = Event.find(event_id)
    @concert = @event.concert
    @grades = @event.grades
  end

  def reservation_params
    params.require(:reservation).
      permit(:payment_method,
             tickets_attributes: [:id] )
  end

  def has?
    if current_user && (current_user.admin? || current_user.id == @reservation.user_id)
      allow
    else
      deny
    end
  end
end
