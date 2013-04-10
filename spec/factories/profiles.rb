# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    location        "MyString"
    website         "MyString"
    bio             "MyString"
    twitter         "MyString"
    facebook        "MyString"
    profile_photo   "MyString"
    favorite_club   "MyString"
    association     :user
  end
end
