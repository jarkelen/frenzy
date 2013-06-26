FactoryGirl.define do
  sequence :email do |n|
    "user#{n}#{n}#{n}#{n}#{n}#{n}@factory#{n}#{n}.com"
  end

  factory :user do
    base_nr           1
    first_name        "Piet"
    last_name         "Jansen"
    team_name         "Frenzy Utd"
    role              "user"
    language          "nl"
    password          "password1"
    participation_due nil
    email
    location          "Eindhoven"
    website             "MyString"
    bio               "MyString"
    twitter           "MyString"
    facebook          "MyString"
    association :favorite_club, factory: :club
  end
end
