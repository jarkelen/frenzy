FactoryGirl.define do
  factory :club do
    club_name   "Charlton Athletic"
    period1     125
    period2     125
    period3     125
    period4     125
    association :league
  end
end
