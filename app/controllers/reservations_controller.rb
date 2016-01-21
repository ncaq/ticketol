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
    if current_user && current_user.buyer?
      allow
      create_reservation_form
      respond_to do |format|
        if @reservation = @reservation_form.record_save
          format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        else
          format.html {
            @event = @reservation_form.grade.event
            render :new
          }
        end
      end
    else
      deny
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    if params[:reservation_form_enable_lottery]
      params.require(:reservation_form_enable_lottery).permit(:grade_id, :payment_method, :volume)
    else
      params.require(:reservation_form_disable_lottery).permit(:grade_id, :payment_method, tickets_attributes: [:id])
    end
  end

  def create_reservation_form
    @reservation_form = params[:reservation_form_enable_lottery] ? ReservationFormEnableLottery.new(reservation_params) : ReservationFormDisableLottery.new(reservation_params)
    @reservation_form.user = current_user
  end
end
