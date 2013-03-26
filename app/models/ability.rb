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
      can    :manage, Selection
      can    :manage, Joker
    end
  end
end
