# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsitem do
    title_nl    "MyString"
    title_en    "MyString"
    content_nl  "MyText"
    content_en  "MyText"
    summary_nl  "MyText"
    summary_en  "MyText"
    publish     true
    sticky      true
    priority    "normal"
    association :user
  end
end
