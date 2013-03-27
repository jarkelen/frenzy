require 'spec_helper'

describe FrenzyCalculator do


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
end