require 'rmagick'

class Concert < ActiveRecord::Base
  belongs_to :user

  has_many :events, :dependent => :destroy
  accepts_nested_attributes_for :events

  before_save :set_default_value

  def set_default_value
    if self.image.nil?
      i = Magick::Image.new(200, 200, Magick::GradientFill.new(0, 0, 200, 0, '#' + '%06x' % rand(0..255).to_s, '#' + '%06x' % rand(0..255).to_s))
      self.image = i.to_blob { self.format = 'png' }
    end
  end

  def uploaded_file=(file)
    self.image = file.read
  end

  def destroy_ok?
    !self.events.any?(&:sell_start?)
  end
end
