# coding: utf-8
class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :destroy, :image]

  # GET /concerts
  def index
    allow
    if q = params[:q]
      @concerts = Concert.where(
        Concert.arel_table[:title].matches("%#{q}%").or(
        Concert.arel_table[:artist].matches("%#{q}%")
      )).order(:updated_at).reverse_order.sort{|c| c.events.any?(&:sell_ok?) ? 0 : 1 }
    elsif user_id = params[:user_id]
      @concerts = Concert.where(user_id: user_id).order(:updated_at).reverse_order
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
    if current_user && (current_user.admin? || current_user.seller?)
      allow
      @concert = Concert.new
      @concert.events.build
      @concert.events.map { |e|
        e.grades.build
        e.grades.map { |g|
          g.tickets.build
        }
      }
    else
      deny
    end
  end

  # POST /concerts
  def create
    if current_user && (current_user.admin? || current_user.seller?)
      allow
      @concert = Concert.new(concert_params) { |c|
        c.user = current_user
      }
      respond_to do |format|
        if @concert.save
          format.html { redirect_to @concert, notice: 'Concert was successfully created.' }
        else
          format.html { render :new }
        end
      end
    else
      deny
    end
  end

  def destroy
    if self.had? && @concert.destroy_ok?
      allow
      @concert.destroy
      flash[:success] = "concert deleted"
      redirect_to :root
    else
      deny
    end
  end

  def image
    allow
    send_data @concert.image, type: 'image/png', disposition: 'inline'
  end

  def had?
    current_user && current_user.admin? || (current_user.seller? && current_user == @concert.user)
  end
  helper_method :had?

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
end
