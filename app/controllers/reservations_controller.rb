class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :destroy]

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
    has?
  end

  def new
    @event = Event.find(params[:event][:id])
    @grades = @event.grades
    @concert = @event.concert
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
    reservation = Reservation.new
    reservation.user_id = current_user.id
    reservation.payment_method = reservation_params[:payment_method]
    grade = Grade.find(reservation_params[:grade][:id])
    event = grade.event
    volume = reservation_params[:volume]
    if current_user && current_user.buyer? && event.sell_time?
      allow
      respond_to do |format|
        if @event.lottery ? reservation.lottery(grade, volume) : reservation.notLottery(reservation_params[:tickets_attributes])
          format.html { redirect_to reservation, notice: 'Reservation was successfully created.' }
          format.json { render :show, status: :created, location: reservation }
        else
          format.html {
            params[:event][:id] = event.id
            render :new
          }
          format.json { render json: reservation.errors, status: :unprocessable_entity }
        end
      end
    else
      deny
    end
  end

  def destroy
    if has? && !@reservation.event.sell_end?
      allow
      self.lottery_pendings.delete_all
      self.destroy
    else
      deny
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
    @event = @reservation.event
  end

  def reservation_params
    params.require(:reservation).permit(:payment_method, tickets_attributes: [:id, :_destroy] )
    params.permit(grade: [:id])
  end

  def has?
    if current_user && (current_user.admin? || current_user.id == @reservation.user_id)
      allow
    else
      deny
    end
  end
end
