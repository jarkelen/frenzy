require 'spec_helper'

describe Calculator do
  let!(:setting)   { create(:setting) }
  let!(:game)      { create :game, name: "Clubs Frenzy" }
  let!(:period)    { create_list(:period, 4) }
  let!(:user)      { create :user }
  let!(:gameround) { create :gameround }
  let!(:club1)     { create :club }
  let!(:club2)     { create :club }

  before :each do
    @calculator = Calculator.new
  end

  describe "new" do
    it "returns a Calculator object" do
      @calculator.should be_an_instance_of Calculator
    end
  end

  describe "process_gameround" do
    let!(:club3)     { create :club }
    let!(:club4)     { create :club }
    let!(:player)    { create :player, user: user, game: game }
    let!(:result1)   { create :result, home_club_id: club1.id, away_club_id: club2.id, home_score: 2, away_score: 1, gameround_id: gameround.id }
    let!(:result2)   { create :result, home_club_id: club3.id, away_club_id: club4.id, home_score: 0, away_score: 3, gameround_id: gameround.id }

    it "should calculate the club scores" do
      expect {
        @calculator.process_gameround(gameround.id)
      }.to change(Score, :count).by(4)

      gameround.reload.processed.should be_true
    end
  end

  describe "calculate_club_score" do
    let!(:club3)     { create :club }
    let!(:club4)     { create :club }
    let!(:result1)   { create :result, home_club_id: club1.id, away_club_id: club2.id, home_score: 2, away_score: 1, gameround_id: gameround.id }
    let!(:result2)   { create :result, home_club_id: club3.id, away_club_id: club4.id, home_score: 0, away_score: 3, gameround_id: gameround.id }

    it "calculates the home score" do
      subject = Calculator.new.calculate_club_score("home", result1, gameround.id)
      subject.should == 4
    end

    it "calculates the home score" do
      subject = Calculator.new.calculate_club_score("home", result2, gameround.id)
      subject.should == -3
    end
  end

  describe "calculate_player_score" do
    let!(:player)    { create :player, user: user, game: game }
    let!(:selection1){ create :selection, club: club1, player: player }
    let!(:selection2){ create :selection, club: club2, player: player }
    let!(:score1)    { create :score, club: club1, gameround: gameround, score: 3 }
    let!(:score2)    { create :score, club: club2, gameround: gameround, score: 5 }

    it "calculates the player score" do
      subject = Calculator.new.calculate_player_score(player, gameround.id)
      subject.should == 8
    end

    context "jokers" do
      let!(:user)      { create :user }
      let!(:player)    { create :player, user: user, game: game }
      let!(:selection1){ create :selection, club: club1, player: player }
      let!(:selection2){ create :selection, club: club2, player: player }
      let!(:score1)    { create :score, club: club1, gameround: gameround, score: 3 }
      let!(:score2)    { create :score, club: club2, gameround: gameround, score: 5 }
      let!(:joker)     { create :joker, club: club2, player: player, gameround: gameround }

      it "doubles the player score when there are jokers" do
        subject = Calculator.new.calculate_player_score(player, gameround.id)
        subject.should == 13
      end
    end
  end

  describe "calculate_total_ranking" do
    let!(:player_top)             { create(:player, user: user, game: game) }
    let!(:player_bottom)          { create(:player, user: user, game: game) }
    let!(:gameround1)             { create(:gameround) }
    let!(:gameround2)             { create(:gameround) }
    let!(:player_top_ranking1)    { create(:ranking, player: player_top, gameround: gameround1, total_score: 10) }
    let!(:player_top_ranking2)    { create(:ranking, player: player_top, gameround: gameround2, total_score: 5) }
    let!(:player_bottom_ranking1) { create(:ranking, player: player_bottom, gameround: gameround1, total_score: 2) }
    let!(:player_bottom_ranking2) { create(:ranking, player: player_bottom, gameround: gameround2, total_score: 6) }

    xit "should rank highest user as first" do
      subject = Calculator.new.calculate_total_ranking('general')
      subject.should =~ [[player_top, 15], [player_bottom, 8]]
    end
  end

end

