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
      can    [:read], Score

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:create, :update, :destroy], League
      cannot [:create, :update, :destroy], Club
      cannot [:create, :update, :destroy], User
      cannot [:index, :administrate_frenzy], Frenzy
    end
  end
end
