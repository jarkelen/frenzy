class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can    [:read, :create, :update, :destroy], Selection
      can    [:read, :create, :update, :destroy, :store], Joker
      can    [:read, :create, :update], Profile
      can    [:read], Result
      can    [:read], Score
      can    [:read], Ranking
      can    [:index, :show], User
      can    [:read], Newsitem
      can    [:read, :create], Comment
      can    [:rules], Frenzy

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:read, :create, :update, :destroy], League
      cannot [:read, :create, :update, :destroy], Period
      cannot [:read, :create, :update, :destroy], Club
      cannot [:create, :update, :destroy], User
      cannot [:create, :update, :destroy], Newsitem
      cannot [:update, :destroy], Comment
      cannot [:index, :process_gameround, :cancel_jokers, :switch_period, :switch_participation], Frenzy
    end
  end
end
