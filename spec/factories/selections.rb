# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :selection do
    association :club
    association :user
  end
end