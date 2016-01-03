class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  # GET /events/1
  # GET /events/1.json
  def show
    allow
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
end
