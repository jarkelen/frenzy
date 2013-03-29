FactoryGirl.define do
  factory :user do
    first_name    "Piet"
    last_name     "Jansen"
    team_name     "Frenzy Utd"
    role          "user"
    language      "nl"
    password      "password1"
    sequence(:email){|n| "user#{n}#{n}@factory#{n}#{n}.com" }
  end
end