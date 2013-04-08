require 'spec_helper'

describe "Frenzy calculations" do
  before :all do
    $max_jokers = 40
    $current_period = 1
    FactoryGirl.create_list(:period, 4)
  end

  before :each do
    @user = FactoryGirl.create(:user, role: 'admin')
    sign_in_as(@user)
  end

  context "switching participation on" do
    @participation = FactoryGirl.create(:setting, participation: true)

    it "should show participation off button" do
      visit frenzy_index_path
      page.should have_selector("input[type=submit][value='Deelname uit']")

      click_button("Deelname uit")
      page.should have_content("De deelname is geswitched")
    end
  end

  context "switching participation off" do
    @participation = FactoryGirl.create(:setting, participation: false)

    it "should show participation on button" do
      visit frenzy_index_path
      page.should have_selector("input[type=submit][value='Deelname aan']")

      click_button("Deelname uit")
      page.should have_content("De deelname is geswitched")
    end
  end
end
