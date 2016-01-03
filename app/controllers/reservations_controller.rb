class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show]

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    if current_user.admin? || current_user.id == @reservation.user_id
      allow
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
end
