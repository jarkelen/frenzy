require 'spec_helper'

describe "Gamerounds" do
  let!(:setting)  { create(:setting) }
  let!(:game)     { create(:game, name: "Clubs Frenzy") }
  let!(:period)   { create_list(:period, 4) }
  let!(:user)     { create(:user) }

  context "unregistered visitors" do
    it "should not allow access" do
      visit gamerounds_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(user)
    end

    it "should not allow access" do
      visit gamerounds_path
      page.should have_content(I18n.t('.general.not_authorized'))
    end
  end

  context "admin users" do
    before(:each) do
      admin = create_user('admin')
      sign_in_as(admin)
    end

    describe "index" do
      let!(:gameround){ create(:gameround) }

      it "should show all gamerounds" do
        visit gamerounds_path
        page.should have_content(gameround.number)
      end

      it "should show add button" do
        visit gamerounds_path
        page.should have_content("Toevoegen")
      end
    end

    describe "new" do
      let!(:period){ create(:period, period_nr: 10) }

      it "should create a new gameround" do
        visit gamerounds_path
        click_link "Toevoegen"
        select "#{period.period_nr}: #{period.start_date.strftime('%d-%m-%Y')} - #{period.end_date.strftime('%d-%m-%Y')}", from: "gameround_period_id"
        fill_in "gameround_number", with: "11"
        select "1", from: "gameround_start_date_3i"
        select "augustus", from: "gameround_start_date_2i"
        select "2013", from: "gameround_start_date_1i"
        select "5", from: "gameround_end_date_3i"
        select "augustus", from: "gameround_end_date_2i"
        select "2013", from: "gameround_end_date_1i"
        click_button "Opslaan"

        page.should have_content("Gameround #{I18n.t('.created.success')}")
        page.should have_content("11")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "edit" do
      let!(:gameround){ create(:gameround) }

      it "should edit a gameround" do
        visit gamerounds_path
        click_link "Wijzigen"
        fill_in "gameround_number", with: "11"
        click_button "Opslaan"

        page.should have_content("Gameround #{I18n.t('.updated.success')}")
        page.should have_content("11")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "delete" do
      let!(:gameround){ create(:gameround) }

      it "should delete a gameround" do
        visit gamerounds_path
        click_link "Verwijderen"

        page.should have_content("Gameround #{I18n.t('.destroyed.success')}")
      end
    end
   end

end