# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :joker do
    association :gameround
    association :user
    association :club
  end
end