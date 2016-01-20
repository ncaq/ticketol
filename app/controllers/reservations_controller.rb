class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]

  def index
    allow
    if current_user.nil?
      redirect_to new_user_session_url
    else
      if current_user.admin?
        @reservations = Reservation.all
      else
        @reservations = Reservation.where(user_id: current_user.id)
      end
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    if current_user && (current_user.admin? || current_user.id == @reservation.user_id)
      allow
    else
      deny
    end
  end

  def new
    @event = Event.find(params[:event][:id])
    @grades = @event.grades
    @concert = @event.concert
    if current_user.nil?
      allow
      redirect_to new_user_session_url
    else
      if @event.sell_time? && current_user.buyer?
        allow
        if @event.lottery
          @reservation_form = ReservationFormEnableLottery.new
        else
          @reservation_form = ReservationFormDisableLottery.new
          @reservation_form.tickets.build
        end
      else
        deny
      end
    end
  end

  def create
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
  end
end
