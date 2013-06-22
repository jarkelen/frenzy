require 'spec_helper'

describe "Leagues" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit leagues_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(@user)
    end

    it "should not allow access" do
      visit leagues_path
      page.should have_content(I18n.t('.general.not_authorized'))
    end
  end

  context "admin users" do
    before(:each) do
      @admin = create_user('admin')
      sign_in_as(@admin)
    end

    describe "index" do
      it "should show all leagues" do
        @league = FactoryGirl.create(:league, league_name: "Premier League")
        visit leagues_path
        page.should have_content(@league.league_name)
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