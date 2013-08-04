require 'spec_helper'

describe "Participation" do
  context "unregistered visitors" do
    it "should not allow access to my team page" do
      visit selections_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to my jokers page" do
      visit jokers_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to my scores page" do
      visit scores_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    let!(:setting)  { create(:setting) }
    let!(:game)     { create(:game, name: "Clubs Frenzy") }
    let!(:period)   { create_list(:period, 4) }
    let!(:user)     { create(:user) }
    let!(:player)   { create(:player, user: user) }

    before(:each) do
      sign_in_as(user)
    end

    describe "my team page" do
      let!(:club1)      { create :club, club_name: "Arsenal", period1: 20 }
      let!(:club2)      { create :club, club_name: "Everton", period1: 12 }
      let!(:selection1) { create :selection, club: club1, player: player }
      let!(:selection2) { create :selection, club: club2, player: player }

      it "should show my team page" do
        visit selections_path
        page.should have_content(I18n.t('team.my_team'))
        page.should have_content(user.team_name)
      end

      it "should show points used" do
        visit selections_path
        page.should have_content("32 #{I18n.t('team.used_points2')} #{player.team_value}")
      end
    end

    describe "my jokers page" do
      before :each do
        visit jokers_path
      end

      it "should show my jokers page" do
        page.should have_content(I18n.t('joker.jokers'))
      end
    end

  end

  describe "restrictions" do
    let!(:game)     { create(:game, name: "Clubs Frenzy") }
    let!(:period)   { create_list(:period, 4) }

    context "participation open, existing user" do
      let!(:setting) { create(:setting, participation: true) }
      let!(:user)     { create(:user) }

      it "should be possible to add/edit the team" do
        sign_in_as(user)

        visit selections_path
        page.should have_content("Toevoegen club")
      end
    end

    context "participation closed, existing user" do
      let!(:setting) { create(:setting, participation: false) }
      let!(:user)    { create(:user) }
      let!(:player)  { create(:player, user: user, participation_due: "") }

      it "should not be possible to add/edit the team" do
        sign_in_as(user)

        visit selections_path
        page.should_not have_content("Toevoegen club")
      end
    end

    context "participation closed, new user" do
      let!(:setting) { create(:setting, participation: false) }
      let!(:user)    { create(:user) }
      let!(:player)  { create(:player, user: user, participation_due: 3.days.from_now) }

      it "should be possible to add/edit the team" do
        sign_in_as(user)

        visit selections_path
        page.should have_content("Toevoegen club")
      end
    end
  end
end
