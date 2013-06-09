require 'spec_helper'

describe "Clubs" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit clubs_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(@user)
    end

    it "should be able to see clubs" do
      @club = FactoryGirl.create(:club, club_name: "Charlton Athletic")
      visit clubs_path
      page.should have_content(@club.club_name)
    end

    it "should not show crud buttons" do
      visit clubs_path
      page.should_not have_content("Toevoegen")
      page.should_not have_content("Wijzigen")
      page.should_not have_content("Verwijderen")
    end
  end

  context "admin users" do
    before(:each) do
      @admin = create_user('admin')
      sign_in_as(@admin)
    end

    describe "index" do
      it "should show all clubs" do
        @club = FactoryGirl.create(:club, club_name: "Charlton Athletic")
        visit clubs_path
        page.should have_content(@club.club_name)
      end

      it "should show add button" do
        visit clubs_path
        page.should have_content("Toevoegen")
      end
    end

    describe "show" do
      let!(:club) { create :club, club_name: "Arsenal" }
      let!(:selection) { create :selection, user: @user, club: club }

      it "should show club details" do
        visit club_path(club)

        page.should have_content(club.club_name)
        page.should have_content(club.league.league_name)
        page.should have_content(club.period1)
        page.should have_content(club.period2)
        page.should have_content(club.period3)
        page.should have_content(club.period4)
      end

    end

    describe "new" do
      it "should create a new club" do
        @league = FactoryGirl.create(:league, league_name: "The Championship")
        visit clubs_path
        click_link "Toevoegen"

        fill_in "club_club_name", with: "Charlton Athletic"
        fill_in "club_period1", with: "24"
        fill_in "club_period2", with: "24"
        fill_in "club_period3", with: "24"
        fill_in "club_period4", with: "24"
        select @league.league_name, from: "club_league_id"
        click_button "Opslaan"

        page.should have_content("Club #{I18n.t('.created.success')}")
        page.should have_content("Charlton Athletic")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "edit" do
      it "should edit a club" do
        @club = FactoryGirl.create(:club)
        visit clubs_path
        click_link "Wijzigen"
        fill_in "club_club_name", with: "Barnet"
        click_button "Opslaan"

        page.should have_content("Club #{I18n.t('.updated.success')}")
        page.should have_content("Barnet")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "delete" do
      it "should delete a club" do
        @club = FactoryGirl.create(:club)
        visit clubs_path
        click_link "Verwijderen"

        page.should have_content("Club #{I18n.t('.destroyed.success')}")
        page.should_not have_content(@club.club_name)
      end
    end
   end

end