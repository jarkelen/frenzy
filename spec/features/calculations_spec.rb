require 'spec_helper'

describe "Frenzy calculations" do
  before do
    init_settings
    @admin = create_user('admin')
    sign_in_as(@admin)
  end

  describe "switching participation" do
    it "should turn off participation" do
      visit frenzy_index_path
      page.should have_selector("input[type=submit][value='Deelname uit']")

      click_button("Deelname uit")
      page.should have_content("De deelname is geswitched")
      page.should have_selector("input[type=submit][value='Deelname aan']")
    end

    it "should turn on participation again" do
      visit frenzy_index_path
      click_button("Deelname uit")
      page.should have_selector("input[type=submit][value='Deelname aan']")

      click_button("Deelname aan")
      page.should have_content("De deelname is geswitched")
      page.should have_selector("input[type=submit][value='Deelname uit']")
    end
  end

  describe "participation on" do
    before do
      visit frenzy_index_path
      click_button("Deelname uit")
    end

    it "should not be possible to add clubs" do
      visit selections_path
      page.should_not have_selector("input[type=submit][value='Club toevoegen']")
      page.should_not have_selector("input[type=submit][value='Verwijderen']")
    end
  end

  describe "joker cancellation" do
    let!(:gameround1) { create :gameround, number: 1, processed: false }
    let!(:gameround2) { create :gameround, number: 2, processed: true }
    let!(:club1)     { create :club, club_name: "Arsenal" }
    let!(:club2)     { create :club, club_name: "Chelsea" }
    let!(:club3)     { create :club, club_name: "Fulham" }
    let!(:joker1)    { create :joker, club: club1, gameround: gameround1, user: @admin }
    let!(:joker2)    { create :joker, club: club2, gameround: gameround1, user: @admin }
    let!(:joker3)    { create :joker, club: club3, gameround: gameround1, user: @admin }
    let!(:score1)    { create :score, club: club1, gameround: gameround1 }
    let!(:score2)    { create :score, club: club2, gameround: gameround1 }
    let!(:score3)    { create :score, club: club3, gameround: gameround1 }

    it "should show all jokers for active gameround" do
      visit jokers_path
      page.should have_content(club1.club_name)
      page.should have_content(club2.club_name)
    end

    it "should show used joker count" do
      visit jokers_path
      page.should have_content("Jokers verbruikt: 3 van de #{@admin.assigned_jokers}")
    end

    it "should not show cancelled jokers" do
      visit jokers_path
      page.should have_content("Jokers verbruikt: 3 van de #{@admin.assigned_jokers}")

      visit frenzy_index_path
      select club1.club_name, from: 'line_1_home_club_id'
      select club2.club_name, from: 'line_1_away_club_id'
      click_button 'Jokers annuleren'

      visit jokers_path
      page.should_not have_content(club1.club_name)
      page.should_not have_content(club2.club_name)
      page.should have_content(club3.club_name)
      page.should have_content("Jokers verbruikt: 1 van de #{@admin.assigned_jokers}")
    end

  end
end

=begin
      let!(:result1)   { create :result, home_club_id: club1.id, away_club_id: club2.id, home_score: 2, away_score: 1, gameround_id: gameround.id }
      let!(:result2)   { create :result, home_club_id: club3.id, away_club_id: club4.id, home_score: 0, away_score: 3, gameround_id: gameround.id }
=end