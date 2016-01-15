# coding: utf-8
class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :edit, :update, :image]

  # GET /concerts
  def index
    allow
    if params[:q]
      q = params[:q]
      @concerts = Concert.where(
        Concert.arel_table[:title].matches("%#{q}%").or(
        Concert.arel_table[:artist].matches("%#{q}%")
      )).sort{|c| c.events.any?(&:sell_ok?) ? 0 : 1 }
    else
      @concerts = Concert.all
    end
  end

  # GET /concerts/1
  def show
    allow
  end

  # GET /concerts/new
  def new
    write?
    @concert = Concert.new
    @concert.events.build
    @concert.events.map { |e|
      e.grades.build
      e.grades.map { |g|
        g.tickets.build
      }
    }
  end

  # POST /concerts
  def create
    write?
    @concert = Concert.new(concert_params)
    @concert.user_id = current_user.id

    respond_to do |format|
      if @concert.save
        format.html { redirect_to @concert, notice: 'Concert was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def image
    allow
    send_data @concert.image, type: 'image/png', disposition: 'inline'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_concert
    @concert = Concert.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def concert_params
    params.require(:concert).permit(
      :title, :artist, :uploaded_file,
      events_attributes: [:place, :date, :sell_start, :sell_end, :lottery,
                          grades_attributes: [:name, :price,
                                              tickets_attributes: [:seat]]])
  end

  def write?
    if current_user && (current_user.admin? || current_user.seller?)
      allow
    else
      deny
    end
  end
end
