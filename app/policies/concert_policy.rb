class ConcertPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.seller?
  end

  def update?
    user.seller? && user.id == record.user_id
  end
end
