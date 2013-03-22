class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      cannot :manage, Gameround
      cannot :manage, Result
      cannot :manage, Club
      cannot :manage, League
    end
  end
end
