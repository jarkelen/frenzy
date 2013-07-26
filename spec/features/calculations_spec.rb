require 'spec_helper'

describe "Frenzy calculations" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user) }
  let!(:admin)     { create(:user, role: "admin") }

  before do
    sign_in_as(admin)
  end

  let!(:setting)   { create(:setting) }
  let!(:game)      { create :game, name: "Clubs Frenzy" }
  let!(:period)    { create_list(:period, 4) }
  let!(:player)     { create :player, user: admin }
  let!(:club1)      { create :club, club_name: "Arsenal", period1: 24, period2: 18 }
  let!(:club2)      { create :club, club_name: "Chelsea", period1: 16, period2: 21 }
  let!(:club3)      { create :club, club_name: "Fulham", period1: 11, period2: 16 }
  let!(:club4)      { create :club, club_name: "Everton", period1: 8, period2: 6}
  let!(:selection1) { create :selection, player: player, club: club1 }
  let!(:selection2) { create :selection, player: player, club: club2 }

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
    let!(:gameround1){ create :gameround, number: 1, processed: false }
    let!(:joker1)    { create :joker, club: club1, gameround: gameround1, player: player }
    let!(:joker2)    { create :joker, club: club2, gameround: gameround1, player: player }
    let!(:joker3)    { create :joker, club: club3, gameround: gameround1, player: player }
    let!(:score1)    { create :score, club: club1, gameround: gameround1 }
    let!(:score2)    { create :score, club: club2, gameround: gameround1 }
    let!(:score3)    { create :score, club: club3, gameround: gameround1 }

    xit "should show all jokers for active gameround" do
      visit jokers_path
      page.should have_content(club1.club_name)
      page.should have_content(club2.club_name)
      page.should have_content(club3.club_name)
    end

    it "should show used joker count" do
      visit jokers_path
      page.should have_content("Jokers verbruikt: 3 van de #{player.assigned_jokers}")
    end

    xit "should not show cancelled jokers" do
      visit jokers_path
      page.should have_content("Jokers verbruikt: 3 van de #{player.assigned_jokers}")

      visit frenzy_index_path
      select club1.club_name, from: 'line_1_home_club_id'
      select club2.club_name, from: 'line_1_away_club_id'
      click_button 'Jokers annuleren'

      visit jokers_path
      page.should_not have_content(club1.club_name)
      page.should_not have_content(club2.club_name)
      page.should have_content(club3.club_name)
      page.should have_content("Jokers verbruikt: 1 van de #{player.assigned_jokers}")
    end
  end

  describe "process gameround" do
    let!(:gameround1) { create :gameround, number: 1, processed: false }
    let!(:result1)   { create :result, home_club_id: club1.id, away_club_id: club2.id, home_score: 2, away_score: 1, gameround_id: gameround1.id }

    it "should show scores in scores overview" do
      visit scores_path
      page.should_not have_content(club1.club_name)
      page.should_not have_content(club2.club_name)

      visit frenzy_index_path
      click_button 'Verwerken'
      page.should have_content('De gegevens zijn berekend')

      visit scores_path
      page.should have_content(club1.club_name)
      page.should have_content(club2.club_name)
    end

    it "should not show processed gameround as selectable anymore" do
      visit frenzy_index_path
      click_button 'Verwerken'

      page.should have_content('De gegevens zijn berekend')
      page.should_not have_content("#{I18n.t('.gameround1.gameround')} #{gameround1.number} (#{gameround1.start_date.strftime('%d-%m-%Y')} - #{gameround1.end_date.strftime('%d-%m-%Y')})")
    end
  end

  describe "switch period" do
    let!(:gameround)  { create :gameround, number: 1, processed: true }
    let!(:user)       { create :user, last_name: "Lineker", team_name: "The Big Ears" }
    let!(:player)     { create :player, user: user }
    let!(:selection3) { create :selection, player: player, club: club2 }
    let!(:selection4) { create :selection, player: player, club: club3 }
    let!(:selection5) { create :selection, player: player, club: club4 }
    let!(:ranking1)   { create :ranking, player: player, gameround: gameround, total_score: 25 }

    before do
      visit frenzy_index_path
      click_button 'Switchen periode'
    end

    it "should process the switch successfully" do
      page.should have_content('De periode is geswitched')
    end

    it "should have a new gameround for points gained" do
      visit gamerounds_path
      page.should have_content('1001')
    end

    it "should show a gameround ranking" do
      visit rankings_path
      find('tr', text: admin.team_name).should have_content("-1")
      find('tr', text: user.team_name).should have_content("8")
    end

    it "should show an updated general ranking" do
      visit general_rankings_path
      find('tr', text: admin.team_name).should have_content("-1")
      find('tr', text: user.team_name).should have_content("33")
    end

    it "should show an empty new period ranking" do
      visit period_rankings_path

      page.should have_content("Periode 2")
      find('tr', text: admin.team_name).should have_content("0")
      find('tr', text: user.team_name).should have_content("0")
    end

  end
end