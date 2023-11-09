class BrandPolicy < ApplicationPolicy
  attr_reader :user, :brand
  
  def initialize(user, brand)
    @user = user
    @brand = brand
  end

  def create?
    user.role == 'admin'
  end

  def update?
    user.role == 'admin'
  end

  def destroy?
    user.role == 'admin'
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
