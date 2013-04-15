require 'spec_helper'

describe "Manage results" do
  before :all do
    init_settings
  end

  before(:each) do
    sign_in_as(@user)
  end

  context "listing leagues" do
    it "should show all leagues" do
      visit leagues_path
      save_and_open_page
    end
  end
end