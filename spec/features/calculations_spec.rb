require 'spec_helper'

describe "Frenzy calculations" do
  before :each do
    init_settings
    @admin = FactoryGirl.create(:user, role: 'admin')
    sign_in_as(@admin)
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
