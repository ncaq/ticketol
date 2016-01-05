class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :edit, :update]

  # GET /concerts
  # GET /concerts.json
  def index
    allow
    @concerts = Concert.all
  end

  # GET /concerts/1
  # GET /concerts/1.json
  def show
    allow
  end

  # GET /concerts/new
  def new
    write?
    @concert = Concert.new
    @concert.build_concert_image
    @concert.events.build
    @concert.events.map { |e|
      e.grades.build
      e.grades.map { |g|
        g.tickets.build
      }
    }
  end

  # POST /concerts
  # POST /concerts.json
  def create
    write?
    @concert = Concert.new(concert_params) { |c|
      c.user_id = current_user.id
      if concert_params[:concert_image_attributes].nil?
        c.concert_image = ConcertImage.new
      end
    }

    respond_to do |format|
      if @concert.save
        format.html { redirect_to @concert, notice: 'Concert was successfully created.' }
        format.json { render :show, status: :created, location: @concert }
      else
        format.html { render :new }
        format.json { render json: @concert.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_concert
    @concert = Concert.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def concert_params
    params.require(:concert).
      permit(:title, :artist,
             concert_image_attributes: [:upload],
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
