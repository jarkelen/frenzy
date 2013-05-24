require 'spec_helper'

describe "Site" do
  before :all do
    init_settings
  end

  context "errors" do
    it "should redirect to 404 page when unknow page is requested" do
      visit root_path

      page.should have_content("The page you are looking for is not here")
    end

    it "should redirect to 404 page when unknow page is requested" do
      visit root_path

      User.should_receive(:index).and_raise("oooops")
      visit users_path

      page.should have_content("We are really sorry, but something went wrong")
    end

  end
end
