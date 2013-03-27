require 'spec_helper'

describe FrenzyCalculator do
  before :each do
    @calculator = FrenzyCalculator.new
  end

  describe "#new" do
    it "returns a FrenzyCalculator object" do
        @calculator.should be_an_instance_of FrenzyCalculator
    end
  end

end


=begin
  describe "process gameround" do
    let(:gameround) { create :gameround }
    let(:result) { create :result, home_score: 3, away_score: 1, gameround: gameround }

    context "home club" do
      subject { FrenzyCalculator.new.process_gameround(gameround) }

      it 'should calculate score' do
        #described_class.process_gameround(gameround)
        expect { subject }.to change { Score.count }.by(2)
      end
    end
  end
=end
