# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsitem do
    title_nl "MyString"
    title_en "MyString"
    content_nl "MyText"
    content_en "MyText"
  end
end
