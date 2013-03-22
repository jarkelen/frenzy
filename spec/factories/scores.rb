# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :score do
    score 1
    association :gameround
    association :club
  end
end
