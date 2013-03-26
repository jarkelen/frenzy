class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can    [:read, :create, :update, :destroy], Selection
      can    [:read, :create, :update, :destroy], Joker
      can    [:read], League
      can    [:read], Result

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:create, :update, :destroy], League
      cannot [:create, :update, :destroy], Club
      cannot [:create, :update, :destroy], User
    end
  end
end
