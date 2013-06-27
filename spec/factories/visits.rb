# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visit do
    visit_nr        1
    visit_date      2.years.ago
    league          "The Championship"
    home_club       "Charlton Athletic"
    away_club       "Millwall"
    ground          "The Valley"
    street          "Floyd Road"
    city            "London"
    country         "United Kingdom"
    longitude       1.5
    latitude        1.5
    result          "1-1"
    season          "2012-2013"
    kickoff         "15:00"
    gate            12345
    association     :user
  end
end
