class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can    [:read, :create, :update, :destroy], Selection
      can    [:read, :create, :update, :destroy], Joker
      can    [:read, :create, :update], Profile
      can    [:read], Period
      can    [:read], Result
      can    [:read], Score
      can    [:read], Ranking
      can    [:read], Newsitem
      can    [:read, :create], Comment

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:read, :create, :update, :destroy], League
      cannot [:create, :update, :destroy], Period
      cannot [:create, :update, :destroy], Club
      cannot [:create, :update, :destroy], User
      cannot [:create, :update, :destroy], Newsitem
      cannot [:update, :destroy], Comment
      cannot [:index, :administrate_frenzy], Frenzy
    end
  end
end
