require 'spec_helper'

describe "Frenzy calculations" do
  before :each do
    init_settings
    @admin = create_user('admin')
    sign_in_as(@admin)
  end

  context "switching participation on" do
    it "should show participation off button" do
      visit frenzy_index_path
      page.should have_selector("input[type=submit][value='Deelname uit']")

      click_button("Deelname uit")
      page.should have_content("De deelname is geswitched")
    end
  end
end
