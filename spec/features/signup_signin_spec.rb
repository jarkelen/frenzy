require 'spec_helper'

describe "Manage results" do
  let(:user) { create :user } #, first_name: 'Arie', last_name: 'Admin', role: 'admin' }

  before(:each) do
    sign_in_as(user)
  end

  context "listing leagues" do
    let(:league_pl) { create_league(league_name: 'Premier League', level: 1) }
    let(:league_ch) { create_league(league_name: 'The Championship', level: 2) }

    it "should show all leagues" do
      visit leagues_path
    end
  end
end