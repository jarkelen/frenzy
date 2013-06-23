require 'spec_helper'

describe "Registering" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should show the marketing page" do
      visit root_path
      page.should have_content("The most entertaining game for English football addicts")
    end

    it "should not allow access" do
      visit newsitems_path
      page.should_not have_content(I18n.t('.news.news_title'))
    end
  end

  describe "registered users" do
    context "regular users" do
      before(:each) do
        sign_in_as(@user)
      end

      it "should show the dashboard" do
        visit root_path
        page.should have_content(I18n.t('.news.latest_news'))
      end

      it "should not show the frenzy administration page" do
        visit frenzy_index_path
        page.should_not have_content(I18n.t('frenzy.switch_participation'))
        page.should have_content(I18n.t('.general.not_authorized'))
      end

      it "should show user small profile" do
        visit root_path
        page.should have_content(@user.full_name)
      end
    end

    context "admin users" do
      before(:each) do
        @admin = create_user('admin')
        sign_in_as(@admin)
      end

      it "should show the dashboard" do
        visit root_path
        page.should have_content(I18n.t('.news.latest_news'))
      end

      it "should show user small profile" do
        visit root_path
        page.should have_content(@user.full_name)
      end

      it "should show the frenzy administration page" do
        visit frenzy_index_path
        page.should have_content(I18n.t('frenzy.switch_participation'))
        page.should_not have_content("You are not authorized to view that page")
      end
    end
  end

end