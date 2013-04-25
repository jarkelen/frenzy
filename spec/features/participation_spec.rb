require 'spec_helper'

describe "Participation" do
  context "unregistered visitors" do
    it "should not allow access to my team page" do
      visit selections_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to my jokers page" do
      visit jokers_path
      page.should have_content(I18n.t('.site.signin'))
    end

    it "should not allow access to my scores page" do
      visit scores_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before :all do
      init_settings
    end

    before(:each) do
      sign_in_as(@user)
    end

    describe "my team page" do
      before :each do
        visit selections_path
      end

      it "should show my team page" do
        page.should have_content(I18n.t('team.my_team'))
        page.should have_content(@user.team_name)
      end

      xit "should show points used" do
        @club1 = FactoryGirl.create(:club, period1: 20)
        @club2 = FactoryGirl.create(:club, period1: 12)
        @selection1 = FactoryGirl.create(:selection, club_id: @club1.id, user_id: @user.id)
        @selection2 = FactoryGirl.create(:selection, club_id: @club2.id, user_id: @user.id)

        @used = @user.team_value - (@club1.period1 + @club2.period1)
        @max = @user.team_value
        page.should have_content("#{@used} #{I18n.t('team.used_points2')} #{@max}")
      end
    end

    describe "my jokers page" do
      before :each do
        visit jokers_path
      end

      it "should show my jokers page" do
        page.should have_content(I18n.t('joker.jokers'))
      end
    end
  end

  describe "restrictions" do
    before :each do
      FactoryGirl.create_list :period, 4
    end

    context "participation open, existing user" do
      it "should be possible to add/edit the team" do
        @setting = FactoryGirl.create :setting, participation: true
        @user = FactoryGirl.create :user
        sign_in_as(@user)

        visit selections_path
        page.should have_content(I18n.t('.team.new'))
      end
    end

    context "participation closed, existing user" do
      it "should not be possible to add/edit the team" do
        @setting = FactoryGirl.create :setting, participation: true
        @user = FactoryGirl.create :user
        @setting.update_attributes(participation: false)
        sign_in_as(@user)

        visit selections_path
        save_and_open_page
        page.should_not have_content(I18n.t('.team.new'))
      end
    end

    context "participation closed, new user" do
      it "should be possible to add/edit the team" do
        @setting = FactoryGirl.create :setting, participation: false
        @user = FactoryGirl.create :user, participation_due: 3.days.from_now
        sign_in_as(@user)

        visit selections_path
        page.should have_content(I18n.t('.team.new'))
      end
    end
  end
end
