require 'spec_helper'

describe "Frenzy calculations" do
  before :each do
    init_settings
    @admin = create_user('admin')
    sign_in_as(@admin)
  end

  context "switching participation" do
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

  context "participation on" do
    before :each do
      visit frenzy_index_path
      click_button("Deelname uit")
    end

    it "should not be possible to add clubs" do
      visit selections_path
      page.should_not have_selector("input[type=submit][value='Club toevoegen']")
      page.should_not have_selector("input[type=submit][value='Verwijderen']")
    end
  end
end

=begin

  let!(:setting) { create :setting }

  before :each do
    @calculator = Calculator.new
  end

  describe "new" do
    it "returns a Calculator object" do
      @calculator.should be_an_instance_of Calculator
    end
  end

  describe "process_gameround" do
    let!(:gameround) { create :gameround }
    let!(:club1)     { create :club }
    let!(:club2)     { create :club }
    let!(:club3)     { create :club }
    let!(:club4)     { create :club }
    let!(:result1)   { create :result, home_club_id: club1.id, away_club_id: club2.id, home_score: 2, away_score: 1, gameround_id: gameround.id }
    let!(:result2)   { create :result, home_club_id: club3.id, away_club_id: club4.id, home_score: 0, away_score: 3, gameround_id: gameround.id }

=end