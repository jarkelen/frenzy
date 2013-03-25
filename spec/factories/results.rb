# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :result do
    home_club_id 1
    away_club_id 1
    home_score 1
    away_score 1
    gameround_id 1
  end
end
