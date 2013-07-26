require 'spec_helper'

describe "Jokers" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user, assigned_jokers: 40) }

  context "unregistered visitors" do
    it "should not allow access to jokers page" do
      visit jokers_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(user)
    end

    describe "jokers page" do
      let!(:player)     { create(:player, user: @user) }
      let!(:gameround)  { create(:gameround) }
      let!(:club1)      { create :club, club_name: "Arsenal", period1: 20 }
      let!(:club2)      { create :club, club_name: "Everton", period1: 12 }
      let!(:selection1) { create :selection, club: club1, player: player }
      let!(:selection2) { create :selection, club: club2, player: player }
      let!(:joker1)     { create :joker, club: club1, gameround: gameround, player: player }
      let!(:joker2)     { create :joker, club: club2, gameround: gameround, player: player }

      it "shows the jokers page" do
        visit jokers_path
        page.should have_content(I18n.t('joker.jokers'))
        page.should have_content("Jokers verbruikt: 2 van de 40")
      end

    end
  end
end
