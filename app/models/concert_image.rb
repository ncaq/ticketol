class ConcertImage < ActiveRecord::Base
  belongs_to :concert

  def upload=(file)
    self.data = file.read
  end
end
