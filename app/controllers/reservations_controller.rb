class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]
  before_action :set_event

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    has?
  end

  def new
    write?
    @reservation = Reservation.new
    @reservation.tickets.build
  end

  def create
    write?
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
    @event = Event.find(params[:event_id])
    @concert = @event.concert
    @grades = @event.grades
  end

  def reservation_params
    params.require(:reservation).permit(:payment_method)
  end

  def has?
    if current_user && (current_user.admin? || current_user.id == @reservation.user_id)
      allow
    else
      deny
    end
  end

  def write?
    if current_user
      if current_user.buyer?
        allow
      else
        deny
      end
    else
      redirect_to new_user_session_url
      allow
    end
  end
end
