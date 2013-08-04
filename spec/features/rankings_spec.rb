require 'spec_helper'

describe "Rankings" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)     { create :period }
  let!(:user)     { create(:user) }

  context "unregistered visitors" do
    it "should not allow access to gameround ranking" do
      visit rankings_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to period ranking" do
      visit period_rankings_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to general ranking" do
      visit general_rankings_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    let!(:user2)      { create(:user) }
    let!(:player1)    { create :player, user: user, game: game }
    let!(:player2)    { create :player, user: user2, game: game }
    let!(:gameround)  { create :gameround, number: 1, processed: true, period: period }
    let!(:ranking1)   { create :ranking, gameround: gameround, player: player1, total_score: 23 }
    let!(:ranking2)   { create :ranking, gameround: gameround, player: player2, total_score: 12 }

    before(:each) do
      sign_in_as(user)
    end

    it "should see the gameround ranking" do
      visit rankings_path

      page.should have_content("Speelronde")
      within(".table") do
        page.should have_xpath("//tr[1]", text: "23")
        page.should have_xpath("//tr[2]", text: "12")
      end
    end

    it "should see the period ranking" do
      visit period_rankings_path

      within(".table") do
        page.should have_xpath("//tr[1]", text: "23")
        page.should have_xpath("//tr[2]", text: "12")
      end
    end

    it "should see the general ranking" do
      visit general_rankings_path

      within(".table") do
        page.should have_xpath("//tr[1]", text: "23")
        page.should have_xpath("//tr[2]", text: "12")
      end
    end
  end
end
