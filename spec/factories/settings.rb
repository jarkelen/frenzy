# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    curent_period 1
    max_teamvalue 1
    max_teamsize 1
    participation false
  end
end
