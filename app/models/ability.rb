class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can    [:read, :create, :update, :destroy], Selection
      can    [:read, :create, :update, :destroy, :store], Joker
      can    [:read], Club
      can    [:read], Result
      can    [:read], Score
      can    [:read, :period, :general], Ranking
      can    [:index, :show, :update], User
      can    [:read], Newsitem
      can    [:read, :create], Comment
      can    [:rules], Frenzy
      can    [:index], Period
      can    [:read, :create, :update, :destroy, :all_maps], Visit
      can    [:index, :show], User

      cannot [:read, :create, :update, :destroy], Gameround
      cannot [:create, :update, :destroy], Result
      cannot [:create, :update, :destroy], League
      cannot [:create, :update, :destroy], Period
      cannot [:create, :update, :destroy], Club
      cannot [:create, :update, :destroy], Newsitem
      cannot [:update, :destroy], Comment
      cannot [:index, :process_gameround, :cancel_jokers, :switch_period, :switch_participation], Frenzy
      cannot [:manage], User
    end
  end
end
