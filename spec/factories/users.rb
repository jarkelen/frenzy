FactoryGirl.define do
  sequence :email do |n|
    "user#{n}#{n}#{n}#{n}#{n}#{n}@factory#{n}#{n}.com"
  end

  factory :user do
    first_name    "Piet"
    last_name     "Jansen"
    team_name     "Frenzy Utd"
    role          "user"
    language      "nl"
    password      "password1"
    email
  end
end
