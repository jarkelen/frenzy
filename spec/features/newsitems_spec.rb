require 'spec_helper'

describe "Newsitems" do
  before :all do
    init_settings
  end

  context "unregistered visitors" do
    it "should not allow access" do
      visit newsitems_path
      page.should have_content(I18n.t('.site.signin'))
    end
  end

  context "regular users" do
    before(:each) do
      @news1 = FactoryGirl.create(:newsitem)
      @news2 = FactoryGirl.create(:newsitem)
      sign_in_as(@user)
    end

    describe "newsitems" do
      it "should see newsitems on homepage" do
        visit root_path
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news2.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should_not have_content(I18n.t('.news.new_item'))
      end

      it "should see newsitems on newsitems page" do
        visit newsitems_path
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news2.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should_not have_content(I18n.t('.news.new_item'))
      end

      it "should see newsitem on detail page" do
        visit newsitem_path(@news1)
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should have_content(@news1.content_nl)
        page.should_not have_content(I18n.t('.news.new_item'))
      end
    end

    describe "comments" do
      it "should see comments" do
        @comment1  = FactoryGirl.create(:comment, commentable_id: @news1.id)
        @comment2  = FactoryGirl.create(:comment, commentable_id: @news1.id)
        visit newsitem_path(@news1)

        page.should have_content(@comments1.content)
        page.should have_content(@comments2.content)
      end
    end
  end

  context "admin users" do
    before(:each) do
      @news1 = FactoryGirl.create(:newsitem)
      @news2 = FactoryGirl.create(:newsitem)
      @admin = create_user('admin')
      sign_in_as(@admin)
    end

    describe "index" do
      it "should see newsitems on homepage" do
        visit root_path
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news2.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should have_content(I18n.t('.new', default: I18n.t("helpers.links.new")))
      end

      it "should see newsitems on newsitems page" do
        visit newsitems_path
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news2.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should have_content(I18n.t('.new', default: I18n.t("helpers.links.new")))
      end
    end

    describe "show" do
      before :each do
        @comment1  = FactoryGirl.create(:comment, commentable_id: @news1.id)
        @comment2  = FactoryGirl.create(:comment, commentable_id: @news1.id)
        visit newsitem_path(@news1)
      end

      it "should see newsitem" do
        page.should have_content(I18n.t('.news.back'))
        page.should have_content(I18n.t('.news.news_title'))
        page.should have_content(@news1.title_nl)
        page.should have_content(@news1.summary_nl)
        page.should have_content(@news1.content_nl)
        page.should have_content(@news1.created_at.strftime('%d-%m-%Y'))
        page.should have_content(@news1.user.full_name)
      end

      it "should see the comments" do
        page.should have_content("#{I18n.t('.news.comments')} (2)")
        page.should have_content(@comment1.content)
        page.should have_content(@comment2.content)
        page.should have_content(@comment2.created_at.strftime('%d-%m-%Y'))
      end
    end

    describe "new" do
      it "should create a new newsitem" do
        visit newsitems_path
        click_link I18n.t('.new', default: I18n.t("helpers.links.new"))

        fill_in "newsitem_title_nl", with: "Dit is de titel"
        fill_in "newsitem_title_en", with: "This is the title"
        fill_in "newsitem_summary_nl", with: "Dit is de samenvatting"
        fill_in "newsitem_summary_en", with: "This is the summary"
        fill_in "newsitem_content_nl", with: "Dit is de content"
        fill_in "newsitem_content_en", with: "This is the content"
        click_button I18n.t('.general.save')

        page.should have_content(I18n.t('.news.created'))
        page.should have_content("Dit is de titel")
        page.should have_content("Dit is de samenvatting")
        page.should have_content("Dit is de content")
      end
    end

    describe "edit" do
      it "should edit a newsitem" do
        @newsitem = FactoryGirl.create(:newsitem)
        visit newsitem_path(@newsitem)
        click_link I18n.t('.general.edit')

        fill_in "newsitem_title_nl", with: "Dit is de titel"
        fill_in "newsitem_title_en", with: "This is the title"
        fill_in "newsitem_summary_nl", with: "Dit is de samenvatting"
        fill_in "newsitem_summary_en", with: "This is the summary"
        fill_in "newsitem_content_nl", with: "Dit is de content"
        fill_in "newsitem_content_en", with: "This is the content"
        click_button I18n.t('.general.save')

        page.should have_content(I18n.t('.news.updated'))
        page.should have_content("Dit is de titel")
        page.should have_content("Dit is de samenvatting")
        page.should have_content("Dit is de content")
      end
    end

    describe "delete" do
      it "should delete a newsitem" do
        @newsitem = FactoryGirl.create(:newsitem, title_nl: "Deletable")
        visit newsitem_path(@newsitem)
        page.should have_content(@newsitem.title_nl)
        click_link I18n.t('.destroy', default: I18n.t("helpers.links.destroy"))

        page.should have_content(I18n.t('.news.deleted'))
        page.should_not have_content(@newsitem.title_nl)
      end
    end

  end

end