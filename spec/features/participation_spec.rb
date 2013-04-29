require 'spec_helper'

describe "Participation" do
  before :all do
    init_settings
  end

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
end
