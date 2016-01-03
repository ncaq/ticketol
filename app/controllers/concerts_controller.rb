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
    @concert.events.build
    @concert.events.map do |e|
      e.grades.build
      e.grades.map do |g|
        g.tickets.build
      end
    end
  end

  # GET /concerts/1/edit
  def edit
    write?
  end

  # POST /concerts
  # POST /concerts.json
  def create
    write?
    @concert = Concert.new(concert_params) do |c|
      c.user_id = current_user.id
    end

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

  # PATCH/PUT /concerts/1
  # PATCH/PUT /concerts/1.json
  def update
    write?
    respond_to do |format|
      if @concert.update(concert_params)
        format.html { redirect_to @concert, notice: 'Concert was successfully updated.' }
        format.json { render :show, status: :ok, location: @concert }
      else
        format.html { render :edit }
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
             events_attributes: [:place, :date, :sell_start, :sell_end, :lottery,
                                 grades_attributes: [:name, :price,
                                                     tickets_attributes: [:seat]]])
  end

  def write?
    if current_user.admin? || current_user.seller?
      allow
    else
      deny
    end
  end
end
