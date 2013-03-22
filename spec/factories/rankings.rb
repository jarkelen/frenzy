# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ranking do
    total_score 1
    association :gameround
    association :user
  end
end
