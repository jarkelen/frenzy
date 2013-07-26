# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    rosettes 1
    medals   1
    cups     1
    assigned_jokers 40
    association :user
    association :game
  end
end
