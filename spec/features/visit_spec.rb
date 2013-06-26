require 'spec_helper'

describe "Visits" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit visits_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(@user)
    end

    describe "all maps" do
      let!(:user2)  { create(:user) }
      let!(:visit1) { create(:visit, user: @user, :home_club "Arsenal") }
      let!(:visit2) { create(:visit, user: @user, :home_club "Chelsea") }
      let!(:visit3) { create(:visit, user: user2, :home_club "Fulham") }

      it "should show all visits of all users" do
        visit all_maps_visits_path
        page.should have_content("")
      end
    end

    describe "own visits" do
      let!(:user2)  { create(:user) }
      let!(:visit1) { create(:visit, user: @user, :home_club "Arsenal") }
      let!(:visit2) { create(:visit, user: @user, :home_club "Chelsea") }
      let!(:visit3) { create(:visit, user: user2, :home_club "Fulham") }

      it "should show an overview of all my visits" do
        visit visits_path
        page.should have_content(visit1.home_club)
        page.should have_content(visit2.home_club)
        page.should_not have_content(visit3.home_club)
      end
    end

    describe "create" do
      it "should be possible to add a visit" do
        visit visits_path
        click_button "Toevoegen"

        fill_in "visit_nr", with: "2"
        select "1", from: "visit_date_3i"
        select "januari", from: "visit_date_2i"
        select "2012", from: "visit_date_1i"
        fill_in "league", with: "Premier League"
        fill_in "home_club", with: "Arsenal"
        fill_in "away_club", with: "Chelsea"
        fill_in "season", with: "2012-2013"
        fill_in "result", with: "1-1"
        fill_in "kickoff", with: "15:00"
        fill_in "gate", with: "46372"
        fill_in "ground", with: "Emirates"
        fill_in "street", with: "Floyd Road"
        fill_in "city", with: "London"
        click_button "Opslaan"

        page.should have_content(I18n.t('.visit.created'))
        page.should have_content("01-01-2012")
        page.should have_content("Arsenal v Chelsea")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "edit" do
      let!(:visit) { create(:visit, user: @user) }

      it "should be possible to edit a visit" do
        visit edit_visit_path(visit)
        fill_in "home_club", with: "Nieuwe Naam"
        click_button "Opslaan"

        page.should have_content(I18n.t('.visit.updated'))
        page.should have_content("Nieuwe Naam")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "delete" do
      let!(:visit) { create(:visit, user: @user) }

      it "should be possible to delete a visit" do
        visit visits_path
        find(:xpath, "//a[@href='/visits/#{visit.id}']").click

        page.should have_content(I18n.t('.visit.deleted'))
        page.should_not have_content(visit.hoem_club)
      end
    end

  end
end