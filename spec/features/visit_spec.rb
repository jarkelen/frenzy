require 'spec_helper'

describe "Visits" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user) }

  context "unregistered visitors" do
    it "should not allow access" do
      visit visits_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    describe "all maps" do
      let!(:user2)  { create(:user) }
      let!(:visit1) { create(:visit, user: user, home_club: "Arsenal") }
      let!(:visit2) { create(:visit, user: user, home_club: "Chelsea") }
      let!(:visit3) { create(:visit, user: user2, home_club: "Fulham") }

      it "should show all visits of all users" do
        sign_in_as(user)
        visit all_maps_visits_path
        page.should have_content("")
      end
    end

    describe "own visits" do
      let!(:user2)  { create(:user) }
      let!(:visit1) { create(:visit, user: user, home_club: "Arsenal") }
      let!(:visit2) { create(:visit, user: user, home_club: "Chelsea") }
      let!(:visit3) { create(:visit, user: user2, home_club: "Fulham") }

      it "should show an overview of all my visits" do
        sign_in_as(user)
        visit visits_path
        page.should have_content(visit1.home_club)
        page.should have_content(visit2.home_club)
        page.should_not have_content(visit3.home_club)
      end
    end

    describe "create" do
      it "should be possible to add a visit" do
        sign_in_as(user)
        visit visits_path
        click_link "Toevoegen"

        fill_in "visit_visit_nr", with: "2"
        select "1", from: "visit_visit_date_3i"
        select "januari", from: "visit_visit_date_2i"
        select "2012", from: "visit_visit_date_1i"
        fill_in "visit_league", with: "Premier League"
        fill_in "visit_home_club", with: "Arsenal"
        fill_in "visit_away_club", with: "Chelsea"
        fill_in "visit_season", with: "2012-2013"
        fill_in "visit_result", with: "1-1"
        fill_in "visit_kickoff", with: "15:00"
        fill_in "visit_gate", with: "46372"
        fill_in "visit_ground", with: "Emirates"
        fill_in "visit_street", with: "Floyd Road"
        fill_in "visit_city", with: "London"
        click_button "Opslaan"

        page.should have_content(I18n.t('.visit.created'))
        page.should have_content("01-01-2012")
        page.should have_content("Arsenal v Chelsea")
      end
    end


  end
end