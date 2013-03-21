# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gameround do
    number 1
    start_date "2013-03-21 16:01:07"
    end_date "2013-03-21 16:01:07"
    processed false
    period_id 1
  end
end
