require 'spec_helper'

describe "Users" do
  before(:all) do
    create_user("user")
  end

  before(:each) do
    sign_in_as(@user)
  end

  context "show profile" do
    profile = FactoryGirl.create(:profile)

    it "should show all details" do
      visit user_profile_path(@user)
save_and_open_page
      #page.should have_content(league_pl.league_name)
      #page.should have_content(league_ch.league_name)
    end
  end
end