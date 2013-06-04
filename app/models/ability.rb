class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can    [:read, :create, :update, :destroy], Selection
      can    [:read, :create, :update, :destroy, :store], Joker
      can    [:read], Result
      can    [:read], Score
      can    [:read], Ranking
      can    [:index, :show, :create, :update], User
      can    [:read], Newsitem
      can    [:read, :create], Comment
      can    [:rules], Frenzy
      can    [:index], Period

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:read, :create, :update, :destroy], League
      cannot [:create, :update, :destroy], Period
      cannot [:read, :create, :update, :destroy], Club
      cannot [:destroy], User
      cannot [:create, :update, :destroy], Newsitem
      cannot [:update, :destroy], Comment
      cannot [:index, :process_gameround, :cancel_jokers, :switch_period, :switch_participation], Frenzy
    end
  end
end
