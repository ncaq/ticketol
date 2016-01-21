class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:default, :admin, :buyer, :seller_pending, :seller]

  def active_for_authentication?
    !self.suspend && !self.default?
  end
end
