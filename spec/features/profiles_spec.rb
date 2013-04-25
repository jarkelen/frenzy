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
      page.should have_content(@user2.email)
      page.should have_content(@user2.assigned_jokers)
      page.should have_content(@user2.team_value)
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

    describe "show other user profile" do
      context "filled in profile" do
        it "should show the profile info" do
          @user2 = FactoryGirl.create(:user)
          FactoryGirl.create(:profile, user_id: @user2.id)
          visit user_path(@user2)

          page.should have_content(@user2.full_name)
          page.should_not have_content(I18n.t('.general.not_authorized'))
        end
      end

      context "not filled in profile" do
        it "should show the oops message" do
          @user2 = FactoryGirl.create(:user)
          visit user_path(@user2)
          page.should have_content(I18n.t('.profile.oops'))

          click_link I18n.t(".user.back_to_users")
          page.should have_content(@user2.full_name)
        end
      end
    end

    it "should show all user profiles" do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      visit users_path

      page.should have_content(@user1.full_name)
      page.should have_content(@user2.full_name)
      page.should_not have_content(@user2.email)
      page.should_not have_content(@user2.assigned_jokers)
      page.should_not have_content(@user2.team_value)
      page.should_not have_content(I18n.t('.general.delete'))
    end

    it "should create own profile" do
      visit user_path(@user)
      click_link I18n.t(".profile.intro3")

      fill_in "profile_bio", with: "My bio text"
      fill_in "profile_location", with: "Eindhoven"
      fill_in "profile_favorite_club", with: "Charlton Athletic"
      fill_in "profile_website", with: "www.test.nl"
      fill_in "profile_twitter", with: "DutchAddick"
      fill_in "profile_facebook", with: "Gezichtboek"
      click_button I18n.t(".general.save")

      page.should have_content(I18n.t('.profile.created'))
      page.should have_content("My bio text")
      page.should have_content("Eindhoven")
      page.should have_content("Charlton Athletic")
      page.should have_content("test.nl")
      page.should have_content("Gezichtboek")
    end

  end
end