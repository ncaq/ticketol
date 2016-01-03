class ConcertImagesController < ApplicationController
  before_action :set_concert_image, only: [:show]

  # GET /concert_images/1
  # GET /concert_images/1.json
  def show
    allow
    if @concert_image
      send_data @concert_image.data, type: 'image/png', disposition: 'inline'
    else
      raise NotFound
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_concert_image
    @concert_image = ConcertImage.find(params[:id])
  end
end
