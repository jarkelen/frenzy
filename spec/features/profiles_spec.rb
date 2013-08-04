require 'spec_helper'

describe "Profiles" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user) }

  context "unregistered visitors" do
    it "should not allow access" do
      visit user_path(user)
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "admin users" do
    let!(:club)  { create(:club) }
    let!(:user1) { create(:user, favorite_club: club.id) }
    let!(:user2) { create(:user, favorite_club: club.id, last_name: "Janssen") }
    let!(:admin) { create(:user, role: "admin") }

    before(:each) do
      sign_in_as(admin)
    end

    it "should show profile" do
      visit user_path(admin)
      page.should have_content(user1.full_name)
    end

    it "should show all user profiles" do
      visit users_path

      page.should have_content(user1.full_name)
      page.should have_content(user2.full_name)
    end

    it "can delete a user" do
      visit users_path

      page.should have_content(I18n.t('.general.delete'))
      page.should have_content(user2.full_name)
      find(:xpath, "//tr[contains(.,'#{user2.full_name}')]/td/a", text: I18n.t('.general.delete')).click

      page.should have_content("User #{I18n.t('.destroyed.success')}")
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(user)
    end

    it "should show own empty profile" do
      visit user_path(user)
      page.should have_content(I18n.t('.user.my_account'))
    end

    describe "show other user profile" do
      let!(:user2) { create(:user) }

      context "filled in profile" do
        it "should show the profile info" do
          visit user_path(user2)

          page.should have_content(user2.full_name)
          page.should_not have_content(I18n.t('.general.not_authorized'))
        end
      end
    end

    describe "all user profiles" do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:club)  { create(:club, club_name: "Arsenal") }

      it "should show all user profiles" do
        visit users_path

        page.should have_content(user1.full_name)
        page.should have_content(user2.full_name)
        page.should_not have_content(I18n.t('.general.delete'))
      end

      it "should create own profile" do
        visit user_path(user)
        click_link "Profiel wijzigen"

        fill_in "user_bio", with: "My bio text"
        fill_in "user_location", with: "Eindhoven"
        select "Arsenal", from: "user_favorite_club"
        fill_in "user_website", with: "www.test.nl"
        fill_in "user_twitter", with: "DutchAddick"
        fill_in "user_facebook", with: "Gezichtboek"
        click_button I18n.t(".general.save")

        page.should have_content(I18n.t('.user.updated'))
        page.should have_content("My bio text")
        page.should have_content("Eindhoven")
        page.should have_content("Arsenal")
        page.should have_content("test.nl")
        page.should have_content("Gezichtboek")
      end
    end
  end
end