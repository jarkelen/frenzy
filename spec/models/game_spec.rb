# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Game do
  it { should validate_presence_of :name }
  it { should have_many(:players) }

  describe "default_game" do
    let!(:game) { create :game, name: "Clubs Frenzy" }
    let!(:game2){ create :game, name: "Toto" }

    it "returns clubs frenzy as default game" do
      Game.default_game.should == game
    end

    it "returns toto not as default game" do
      Game.default_game.should_not == game2
    end

  end

end
