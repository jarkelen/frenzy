# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visit do
    visit_nr 1
    visit_date "2013-06-23 18:31:14"
    league_id 1
    home_club_id "MyString"
    integer "MyString"
    away_club_id 1
    ground "MyString"
    street "MyString"
    city "MyString"
    longitude 1.5
    latitude 1.5
    result "MyString"
    season "MyString"
    kickoff "MyString"
    gate 1
    user_id 1
  end
end
