require 'spec_helper'

describe "Leagues" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user) }

  context "unregistered visitors" do
    it "should not allow access" do
      visit leagues_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(user)
    end

    it "should not allow access" do
      visit leagues_path
      page.should have_content(I18n.t('.general.not_authorized'))
    end
  end

  context "admin users" do
    let!(:admin) { create(:user, role: "admin") }

    before(:each) do
      sign_in_as(admin)
    end

    describe "index" do
      let!(:league) { create(:league, league_name: "Premier League") }

      it "should show all leagues" do
        visit leagues_path
        page.should have_content(league.league_name)
      end

      it "should show add button" do
        visit leagues_path
        page.should have_content("Toevoegen")
      end
    end

    describe "new" do
      it "should create a new league" do
        visit leagues_path
        click_link "Toevoegen"

        fill_in "league_league_name", with: "Scottish Premier League"
        fill_in "league_league_short", with: "SPL"
        fill_in "league_level", with: "1"
        click_button "Opslaan"

        page.should have_content("League was successfully created")
        page.should have_content("Scottish Premier League")
      end
    end

   end

end