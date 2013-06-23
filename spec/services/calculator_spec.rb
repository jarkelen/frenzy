require 'spec_helper'

describe Calculator do
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

    it "should calculate the club scores" do
      expect {
        @calculator.process_gameround(gameround.id)
      }.to change(Score, :count).by(4)

      gameround.reload.processed.should be_true
    end

  end

  describe "cancel_jokers" do
    let!(:gameround1) { create :gameround }
    let!(:gameround2) { create :gameround }
    let!(:joker1)     { create :joker, gameround: gameround1 }
    let!(:joker2)     { create :joker, gameround: gameround2 }
    let!(:home_club)  { create :club }
    let!(:away_club)  { create :club }

    xit "should cancel joker of cancelled gameround" do
      expect {
        line = Hash.new
        line[:home_club_id] = home_club.id
        line[:away_club_id] = away_club.id
        line[:gameround_id] = gameround1.id
        @calculator.cancel_jokers(line)
      }.to change(Joker, :count).by(1)
    end
  end
end

