require 'spec_helper'

describe "Profiles" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit user_path(@user)
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "admin users" do
    before(:each) do
      @admin = create_user('admin')
      sign_in_as(@admin)
    end

    it "should show profile" do
      visit user_path(@admin)
      page.should have_content(I18n.t('.profile.my_profile'))
    end

    it "should show all user profiles" do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      visit users_path

      page.should have_content(@user1.full_name)
      page.should have_content(@user2.full_name)
    end

    it "can delete a user" do
      @user1 = FactoryGirl.create(:user, last_name: "Tester")
      visit users_path

      page.should have_content(I18n.t('.general.delete'))
      page.should have_content(@user1.full_name)
      find(:xpath, "//tr[contains(.,'#{@user1.full_name}')]/td/a", text: I18n.t('.general.delete')).click

      page.should have_content("User #{I18n.t('.destroyed.success')}")
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(@user)
    end

    it "should show own empty profile" do
      visit user_path(@user)
      page.should have_content(I18n.t('.profile.my_profile'))
      page.should have_content(I18n.t('.profile.intro1'))
    end

    it "should not show other user profile" do
      @user2 = FactoryGirl.create(:user)
      visit user_path(@user2)

      page.should_not have_content(@user2.full_name)
      page.should have_content(I18n.t('.general.not_authorized'))
    end

  end
end