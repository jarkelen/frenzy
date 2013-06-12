# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prize do
    name  "cup"
    value 25
    association :user
  end
end
