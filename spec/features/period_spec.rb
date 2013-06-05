require 'spec_helper'

describe "Periods" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit periods_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      sign_in_as(@user)
    end

    describe "index" do
      it "should show all periods" do
        @period = FactoryGirl.create(:period)
        visit periods_path
        page.should have_content(@period.name)
      end

      it "should show action buttons" do
        visit periods_path
        page.should_not have_content("Wijzigen")
        page.should_not have_content("Verwijderen")
      end
    end
  end

  context "admin users" do
    before(:each) do
      @admin = create_user('admin')
      sign_in_as(@admin)
    end

    describe "index" do
      it "should show all periods" do
        @period = FactoryGirl.create(:period)
        visit periods_path
        page.should have_content(@period.name)
      end

      it "should show action buttons" do
        visit periods_path
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "edit" do
      it "should edit a period" do
        @period = FactoryGirl.create(:period)
        visit periods_path
        find(:xpath, "//a[@href='/periods/#{@period.id}/edit']").click
        fill_in "period_name", with: "Nieuwe Naam"
        click_button "Opslaan"

        page.should have_content("Periode #{I18n.t('.updated.success')}")
        page.should have_content("Nieuwe Naam")
        page.should have_content("Wijzigen")
        page.should have_content("Verwijderen")
      end
    end

    describe "delete" do
      it "should delete a period" do
        @period = FactoryGirl.create(:period, name: "Test")
        visit periods_path
        find(:xpath, "//a[@href='/periods/#{@period.id}']").click

        page.should have_content("Periode #{I18n.t('.destroyed.success')}")
        page.should_not have_content(@period.name)
      end
    end
   end

end