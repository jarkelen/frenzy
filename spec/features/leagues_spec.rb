require 'spec_helper'

describe "Manage results" do
  before(:all) do
    create_user("admin")
  end

  before(:each) do
    sign_in_as(@user)
  end

  context "listing leagues" do
    league_pl = FactoryGirl.create(:league, league_name: 'Premier League', level: 1)
    league_ch = FactoryGirl.create(:league, league_name: 'The Championship', level: 2)

    it "should show all leagues" do
      visit leagues_path
save_and_open_page
      page.should have_content(league_pl.league_name)
      page.should have_content(league_ch.league_name)
    end
  end
end

=begin
# encoding: utf-8
require 'spec_helper'

describe 'Manage people' do

  before(:each) do
    sign_in
  end

  context 'listing people' do
    # Sorting is temporary disabled due to strange behavoir on Heroku in combination with PgSearch
    # let!(:people) { create_list(:person_with_partner, 4).sort_by(&:surname) }
    let!(:people) { create_list(:person_with_partner, 4) }

    it "should show a list of customers (page 1)" do
      visit people_path(person_status: 'all')

      Person.customers.page(1).each do |person|

        page.should have_content person.franchisee.name
        within "#person_#{person.id}" do
          page.should have_content person.full_name
          page.should have_content person.status.capitalize
        end

      end
    end

    it "should not show the partners listed (page 1 and 2)" do
      person = people.first.partner
      visit people_path(person_status: 'all')
      page.should_not have_css "#person_#{person.id}"
      click_link '2'
      page.should_not have_css "#person_#{person.id}"
    end


    it 'should use pretty URL for pagination to enable caching' do
      visit people_path(person_status: 'all')
      within 'nav.pagination' do
        click_link '2'
      end
      current_path.should eql('/people/page/2')
    end

    it "should show a list of people (page 2)" do
      visit people_path(person_status: 'all')
      within 'nav.pagination' do
        click_link "2"
      end

      Person.customers.page(2).each do |person|
        within "#person_#{person.id}" do
          page.should have_content person.full_name
        end
      end
    end
  end

  context 'list status filter', js: true do

    let!(:franchisee) {create :franchisee}

    let!(:person1)             { create :person, id: 123, franchisee: franchisee }
    let!(:dossier1)            { create :dossier, parent: person1, franchisee: person1.franchisee }
    let!(:this_year_contract)  { create :active_contract_with_care_periods, dossier: dossier1, year: Date.current.year }
    let!(:last_year_contract1) { create :contract_with_care_periods, dossier: dossier1, year: (Date.current.year - 1) }

    let!(:person2)             { create :person, id: 456, franchisee: franchisee }
    let!(:dossier2)            { create :dossier, parent: person2, franchisee: person2.franchisee, childminder: person1 }
    let!(:last_year_contract2) { create :contract_with_care_periods, dossier: dossier2, year: (Date.current.year - 1) }

    let!(:person3)             { create :person, id: 789, franchisee: franchisee }
    let!(:dossier3)            { create :dossier, parent: person3, franchisee: person3.franchisee, childminder: person1 }
    let!(:last_year_contract3) { create :contract_with_care_periods, dossier: dossier3, year: (Date.current.year - 1) }

    it 'should show only person in selected status' do
      visit people_path(person_status: 'all')
      select 'Active', from: 'person_status'
      page.should have_content(person1.full_name)
      page.should_not have_content(person2.full_name)

      select 'Inactive', from: 'person_status'
      page.should have_content(person2.full_name)
      page.should_not have_content(person1.full_name)
    end

    it 'should work with quicksearch', js: true do
      visit people_path
      select 'Inactive', from: 'person_status'
      fill_in 'searchbox', with: '123'
      page.should_not have_content(person1.full_name)
      fill_in 'searchbox', with: '789'
      page.should have_content(person3.full_name)
      page.should_not have_content(person2.full_name)

      fill_in 'searchbox', with: '123'
      select 'Active', from: 'person_status'
      page.should have_content(person1.full_name)
    end
  end

  context 'advanced search' do
    let!(:address1) { create :address, street: 'qwer', city: 'tyui', postalcode: '1234pp' }
    let!(:address2) { create :address, street: 'rewq', city: 'iuyt', postalcode: '4321pp' }

    let!(:person1) { create :person, surname: 'qwer', date_of_birth: '1988-07-14', ssn: '123456789', phone1: '123456', email: 'email@test.com', address: address1 }
    let!(:person2) { create :person, surname: 'rewq', date_of_birth: '1985-12-06', ssn: '987654321', phone1: '654321', email: 'liame@tset.com', address: address2 }

    let!(:dossier1) { create :dossier, :with_active_contract, parent: person1, franchisee: person1.franchisee, contract_year: 2013 }
    let!(:dossier2) { create :dossier, :with_active_contract, childminder: person2, franchisee: person2.franchisee, contract_year: 2013 }


    before { visit people_path }


    it 'should filter by surname' do
      fill_in 'q_surname_cont', with: 'qwe'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by birth day' do
      fill_in 'q_date_of_birth_eq', with: '1988-07-14'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by ssn' do
      fill_in 'ssn', with: '123456789'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by phone1' do
      fill_in 'q_phone1_cont', with: '123'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by email' do
      fill_in 'q_email_cont', with: 'test'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by id' do
      fill_in 'person_id', with: person1.id
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by invoice period month' do
      select 'Parent', from: 'role'
      click_button 'Search'

      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by Postal code' do
      fill_in 'q_address_postalcode_cont', with: '1234'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by street' do
      fill_in 'q_address_street_cont', with: 'qwer'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should filter by city' do
      fill_in 'q_address_city_cont', with: 'tyui'
      click_button 'Search'
      page.should have_element_for(person1)
      page.should_not have_element_for(person2)
    end

    it 'should remember previous selection' do
      fill_in 'q_surname_cont', with: 'qwe'
      fill_in 'q_date_of_birth_eq', with: '14-07-1988'
      fill_in 'ssn', with: '123456789'
      fill_in 'q_phone1_cont', with: '123456789'
      fill_in 'q_email_cont', with: 'test'
      fill_in 'person_id', with: person1.id
      select 'Parent', from: 'role'
      fill_in 'q_address_postalcode_cont', with: '1234'
      fill_in 'q_address_street_cont', with: 'qwer'
      fill_in 'q_address_city_cont', with: 'tyui'

      click_button 'Search'

      find_field('q_surname_cont').value.should == 'qwe'
      find_field('q_date_of_birth_eq').value.should ==  '14-07-1988'
      find_field('ssn').value.should == '123456789'
      find_field('q_phone1_cont').value.should == '123456789'
      find_field('q_email_cont').value.should == 'test'
      find_field('person_id').value.should == person1.id.to_s
      find_field('role').value.should == 'parent'
      find_field('q_address_postalcode_cont').value.should == '1234'
      find_field('q_address_street_cont').value.should == 'qwer'
      find_field('q_address_city_cont').value.should == 'tyui'
    end
  end


  context "when viewing a person" do
    context 'given a normal person' do
      RSpec::Matchers.define :have_person_details do |person|
        match do |page|
          person = PersonDecorator.decorate(person)
          page.should have_content(person.ssn)
          #page.should have_content(person.name)
          page.should have_content(person.date_of_birth)
        end
      end

      let!(:person)                           { create :person }
      let!(:person_parent)                    { create :person_parent }
      let!(:person_childminder)               { create :person_childminder }
      let!(:person_parent_childminder)        { create :person_parent_childminder }
      let!(:franchisee)                       { create :franchisee }

      it "should show all person details" do
        visit person_path(person)
        page.should have_person_details(person)
        page.should have_content person.status.capitalize
      end

      it "should show main person details" do
        visit person_path(person)
        page.should have_content(person.id)
        # within ".statemachine .value" do
        #   page.should have_content "Active" # person.status
        # end
      end

      it 'should show the person origin' do
        person = create :person, origin: 'flexmoeders'
        visit person_path(person)
        page.should have_content('Origin: flexmoeders')
      end

      it 'should list the person address' do
        visit person_path(person)
        page.should have_content person.address.street
        page.should have_content person.address.number
        page.should have_content person.address.addition
        page.should have_content person.address.postalcode
        page.should have_content person.phone1
        page.should have_content person.email
      end

      it 'should show the person franchisee' do
        visit person_path(person)
        page.should have_content person.franchisee.name
      end

      it "should not show downloads links for people without an address" do
        addressless_one = create :person, address: nil
        visit customer_detail_path(addressless_one, page_detail: 'parent_agreement')
        expect { page.find_link('Download Parent Form') }.to raise_error(Capybara::ElementNotFound)

        page.should have_content('Data Missing')
      end

      it "should show correct agreement download/upload links for parent" do
        visit customer_detail_path(person_parent, page_detail: 'parent_agreement')
        find_link('Download Parent Form').should_not be_nil
        find_link('Upload Signed Parent Contract').should_not be_nil

        page.should_not have_content('Download Childminder Form')
        page.should_not have_content('Upload Signed Childminder Contract')
      end

      it "should show correct agreement download/upload links for childminder" do
        visit customer_detail_path(person_childminder, page_detail: 'childminder_agreement')
        # Temporarily disabled
        #find_link('Download Childminder Form').should_not be_nil
        find_link('Upload Signed Childminder Contract').should_not be_nil

        page.should_not have_content('Download Parent Form')
        page.should_not have_content('Upload Signed Parent Contract')
      end

      it "should download agreement form for parent" do
        visit customer_detail_path(person_parent, page_detail: 'parent_agreement')
        click_link('Download Parent Form')
        page.response_headers['Content-Type'].should == 'application/pdf'
      end

      it "should download an authorization form", focus: true do
        visit customer_detail_path(person, page_detail: 'parent_agreement')
        click_link 'Download authorization'
        page.response_headers['Content-Type'].should == 'application/pdf'
      end

      it "should upload an agreement" do
        visit customer_detail_path(person_parent, page_detail: 'parent_agreement')
        click_link('Upload Signed Parent Contract')

        expect {
            fill_in "Signed at", with: Date.today
          attach_file "Agreement", Rails.root.join('spec','fixtures','files','test.jpg')
          click_on "Update"
        }.to change(MediationAgreement, :count).by(1)
      end

      context "invites" do
        context 'when the person has a unique email address' do
          it "shows the invite link" do
            visit person_path(person)
            page.should have_link("Invite")
          end
        end

        context 'when a user with that email address already exists' do
          it 'shows a message instead of an invite link' do
            create :user, email: person.email
            visit person_path(person)
            page.should_not have_link('Invite')
            page.should have_content('This person cannot be invited')
          end
        end

        it 'hides the invite link for franchisees' do
          sign_out
          sign_in_as(create :user_with_franchisee)
          page.should_not have_link("Invite")
        end

        it "shows the invite again link after invitation has been sent" do
          visit person_path(person)
          click_on("Invite")

          page.should have_link(t('people.detail.summary.invite_again'))
          page.should have_content t('people.detail.summary.invited_at')
        end
      end

      context "imported people invites" do
        let(:person) { create :person, origin: "flexmoeders", has_childminder_agreement: true }

        it "receives 1 email" do
          expect {
            person.invite!
          }.to change{ActionMailer::Base.deliveries.size}.by(1)
        end

        it "one of those mails should be the welcome_invitation mail" do
          Devise::Mailer.should_receive(:confirmation_instructions).once.and_return(mock(deliver: true))
          person.invite!
        end

        describe "when user accounts already exists" do
          let(:user) { create :user, person: person }

          it "returns success when person is invited" do
            visit person_path(person)
            click_on("Invite")

            page.should have_content('nvite has been successfully sent to')
          end
        end
      end

      describe "manage the uploaded agreement" do
        before(:each) {
          person_parent.mediation_agreements.create(
            agreement_type: 'parent',
            signed_at: Date.today,
            agreement: fixture_file_upload( Rails.root.join('spec','fixtures','files','test.jpg'), 'image/jpeg')
          )
          visit customer_detail_path(person_parent, page_detail: 'parent_agreement')
        }

        it "should delete the agreement" do
          expect {
            click_on "Delete"
          }.to change(MediationAgreement, :count).by(-1)
          current_path.should eql(customer_detail_path(person_parent, page_detail: 'parent_agreement'))
        end
      end

      context "user adoption" do
        let!(:employee) { create(:user) }
        let!(:user)   { create :user, email: "arie.admin@viaviela.nl", full_name: "Arie Admin" }
        let!(:person) { create :person, user: employee, email: "eddy.employee@viaviela.nl", first_name: "Eddy", surname_prefix: "de", surname: "Employee" }
        let!(:person_without_user_account) { create :person }

        it "should be possible to adopt an user" do
          sign_out
          sign_in_as(user)
          visit person_path(person)
          page.should have_button t("adopt")

          click_button t("adopt")
          page.should have_content("Eddy de Employee")
          page.should_not have_content("Arie Admin")
          within(".adoption_alert") do
            page.should have_content("Attention: You are now logged in as user Eddy de Employee! Return to my own account")
          end

          click_link t("header.abandon")
          page.should have_content("Arie Admin")
          page.should_not have_content("Eddy de Employee")
        end

        it "should not be possible to adopt an user without user account" do
          visit person_path(person_without_user_account)
          page.should_not have_button t("adopt")
        end
      end
    end

    context 'when the person has a partner' do
      let!(:person) { create :person_with_partner }

      it "should show all partner details" do
        visit person_path(person)
        page.should have_person_details(person.partner)
      end
    end

    context 'when the person has no birth date' do
      let!(:person) { create :person, date_of_birth: nil }

      it 'does not raise an exception if the birth date is empty' do
        expect { visit person_path(person) }.not_to raise_error
      end
    end

    context "with children" do
      let!(:person) { create :person, date_of_birth: nil }
      let!(:children) { ChildDecorator.decorate(3.times.collect{ create(:child, parent: person) }) }

      it "should show children details" do
        visit person_path(person)
        children.each do |child|
          page.should have_content(child.name)
          page.should have_content(child.birthdate_wo_age)
        end
      end
    end

    context "with dossiers" do
      let!(:person) { create :person_with_dossiers }
      let!(:person_childminder) { create :person_childminder }
      let!(:franchisee)  { create :franchisee }

      it "should show dossiers details" do
        visit person_path(person)
        dossier = person.dossiers
        dossier.each do |dossier|
          page.should have_content(dossier.reference)
          page.should have_content(dossier.parent.full_name)
          page.should have_content(dossier.childminder.full_name)
          page.should have_content(dossier.franchisee.name)
        end
      end

      it "should not show the dossierkaart link" do
        visit person_path(person)
        page.should_not have_content t(".dossier_file")
      end

      it "should show new dossier button" do
        visit person_path(person)
        page.should have_content t("people.detail.dossiers.new")
      end

      it "should add a new dossier" do
        visit person_path(person)
        click_on t("people.detail.dossiers.new")

        page.should have_content t(".activerecord.attributes.dossier.parent")
      end
    end

    context "without dossiers" do
      let!(:person) { create :person }

      it "should show new dossier button" do
        visit person_path(person)
        page.should have_content t("people.detail.dossiers.new")
      end
    end

    context "with tickets" do
      let!(:person)   { create :person, first_name: 'Arjan' }
      let!(:owner)    { create :user, full_name: 'Ollie Owner'  }
      let!(:creator)  { create :user, full_name: 'Chris Creator' }
      let!(:ticket)   { create :ticket, creator_id: creator.id, owner_id: owner.id, person: person}

      it "should show a list of tickets" do
        visit person_path(person)
        tickets = person.tickets
        tickets.each do |ticket|
          page.should have_content(ticket.id)
          page.should have_content(ticket.person.first_name)
          page.should have_content(ticket.owner.full_name)
          page.should have_content(ticket.creator.full_name)
        end
      end

      context 'when craetor is customer' do
        let!(:creator)  { create :customer }

        it 'should show person full name' do
          visit person_path(person)
          page.should have_content(ticket.creator.person_full_name)
        end
      end

      it 'should show name' do
        visit person_path(person)
        within 'tr.ticket' do
          page.should have_content('Arjan')
        end
      end

      it "should show a link to the ticket details page" do
        visit person_path(person)
        ticket = person.tickets
        ticket.each do |ticket|
          within "#ticket_#{ticket.id}" do
            page.should have_content(ticket.id.to_s)
          end
        end
      end

      it "should have an add ticket button" do
        visit person_path(person)
        page.should have_content("Create Ticket")
      end

    end

    context 'when the parent has invoices' do
      let!(:franchisee)  { create :franchisee }
      let!(:parent)      { create :person, franchisee: franchisee }
      let!(:childminder) { create :childminder, franchisee: franchisee }
      let!(:invoice)     { create :franchisee_invoice, :with_invoice_lines, number: 123, contract_year: 2012, contract_month: 4, invoicable: parent, invoicer: franchisee }

      it "should show all invoices (no pagination yet)" do
        visit customer_detail_path(parent, page_detail: 'parent_invoices')

        within "tr#franchisee_invoice_#{invoice.id}" do
          page.should have_link('123', href: franchisee_invoice_path(invoice))
          page.should have_content('April')
          page.should have_content('2012')
          page.should have_content('€ 50.00')
        end
      end

      it "should show download link to consulents invoice's pdf" do
        FranchiseeInvoicePdfJob.new(invoice).run
        visit customer_detail_path(parent, page_detail: 'parent_invoices')
        within("#franchisee_invoice_#{invoice.id}") do
          click_link("Download")
        end
        page.should be_pdf_document
      end

      it "should show an open invoice amount in the summary for the parent" do
        create :childminder_invoice, :with_invoice_lines, invoicable: parent
        visit person_path(parent)
        page.should have_content('$50.00')
      end
    end
  end

  context "create" do
    let!(:franchisee)  { create :franchisee }

    let(:person)       { build(:person_parent) }
    let(:bank_account) { build(:bank_account) }
    let(:partner)      { build(:partner) }

    context "with filled in required fields" do
      before do
        visit new_person_path
        select franchisee.name, from: 'person_franchisee_id'
        fill_in 'person_first_name', with: person.first_name
        fill_in 'person_initials', with: person.initials
        fill_in 'person_surname', with: person.surname
        select person.gender, from: 'person_gender'
        fill_in 'person_date_of_birth', with: person.date_of_birth
        fill_in 'person_phone1', with: person.phone1
        fill_in 'person_phone2', with: person.phone2
        fill_in 'person_email', with: person.email
        fill_in 'person_working_hours', with: person.working_hours
        choose 'person_single_true'
        fill_in 'person_address_attributes_street', with: person.address.street
        fill_in 'person_address_attributes_number', with: person.address.number
        fill_in 'person_address_attributes_postalcode', with: person.address.postalcode
        fill_in 'person_address_attributes_city', with: person.address.city
        select person.address.country, from: 'person_address_attributes_country'
      end

      it "should create a new person" do
        expect {
          click_button "Create Customer"
        }.to change(Person, :count).by(1)
      end

      it "should create a new person with a bank account" do
        fill_in 'person_bank_account_attributes_name',   with: bank_account.name
        fill_in 'person_bank_account_attributes_number', with: bank_account.number
        fill_in 'person_bank_account_attributes_city',   with: bank_account.city
        check   'person_bank_account_attributes_allow_collection'

        click_button "Create Customer"

        person = Person.last
        person.should have_bank_account
        person.bank_account.name.should   == bank_account.name
        person.bank_account.number.should == bank_account.number
        person.bank_account.city.should   == bank_account.city
      end

      it "should create a person as a parent" do
        choose 'person_has_parent_agreement_true'
        choose 'person_has_childminder_agreement_false'

        click_button "Create Customer"

        p = Person.find_by_email!(person.email)
        p.has_parent_agreement.should == true
        p.has_childminder_agreement.should == false
      end

      it "should create a person as a childminder" do
        choose 'person_has_parent_agreement_false'
        choose 'person_has_childminder_agreement_true'

        click_button "Create Customer"
        current_path.should_not be_nil

        p = Person.find_by_email!(person.email)
        p.has_parent_agreement.should be_false
        p.has_childminder_agreement.should be_true
      end

      it "should create a person as a parent and childminder" do
        choose 'person_has_parent_agreement_true'
        choose 'person_has_childminder_agreement_true'

        click_button "Create Customer"

        p = Person.find_by_email!(person.email)
        p.has_parent_agreement.should be_true
        p.has_childminder_agreement.should be_true
      end

      context "with partner" do
        before do
          choose 'person_single_false'
          fill_in 'person_person_partnership_attributes_partner_attributes_initials',      with: partner.initials
          fill_in 'person_person_partnership_attributes_partner_attributes_first_name',    with: partner.first_name
          fill_in 'person_person_partnership_attributes_partner_attributes_surname',       with: partner.surname
          select partner.gender,                                                           from: 'person_person_partnership_attributes_partner_attributes_gender'
          fill_in 'person_person_partnership_attributes_partner_attributes_date_of_birth', with: partner.date_of_birth
          fill_in 'person_person_partnership_attributes_partner_attributes_phone1',        with: partner.phone1
          fill_in 'person_person_partnership_attributes_partner_attributes_phone2',        with: partner.phone2
          fill_in 'person_person_partnership_attributes_partner_attributes_email',         with: partner.email
          fill_in 'person_person_partnership_attributes_partner_attributes_ssn',           with: partner.ssn
          fill_in 'person_person_partnership_attributes_partner_attributes_working_hours', with: partner.working_hours
        end

        it "should create a new person with a new partner" do
          expect {
            click_button "Create Customer"
          }.to change(Person, :count).by(2)
        end

        it "should create a one way partner relation between person and partner" do
          click_button "Create Customer"

          p1 = Person.find_by_email!(person.email)
          p2 = Person.find_by_email!(partner.email)

          p1.partner.id.should == p2.id
          p2.customer_partner.id.should  == p1.id
        end
      end
    end

    context "when required fields is not filled in" do
      it "should not create a person" do
        visit new_person_path
        select franchisee.name, from: 'person_franchisee_id'
        choose 'person_has_parent_agreement_true'
        choose 'person_has_childminder_agreement_true'

        expect { click_button "Create Customer" }.to_not change(Person, :count)
        page.should have_content("can't be blank")
      end
    end
  end

  context "update" do
    let!(:person3) {  build(:person) }
    let!(:person2) {  build(:person) }
    let!(:person) {  create(:person) }

    it "updates common fields correctly" do
      visit edit_person_path(person)

      select person.franchisee.name, from: 'person_franchisee_id'
      fill_in 'person_initials', with: person.initials
      fill_in 'person_first_name', with: person2.first_name
      fill_in 'person_surname', with: person2.surname
      fill_in 'person_phone1', with: person2.phone1
      fill_in 'person_phone2', with: person2.phone2
      fill_in 'person_email', with: person2.email
      fill_in 'person_working_hours', with: person2.working_hours
      fill_in 'person_ssn', with: person2.ssn
      click_button "Update Basic details"

      person.reload

      current_path.should eql(person_path(person))

      person.first_name.should ==  person2.first_name
      person.surname.should ==  person2.surname
      person.phone1.should ==  person2.phone1
      person.phone2.should ==  person2.phone2
      person.email.should ==  person2.email
      person.working_hours.should ==  person2.working_hours
      person.ssn.should ==  person2.ssn
    end

    it "updates the bank account" do
      bank_account = build(:bank_account)

      visit edit_person_path(person)

      fill_in 'person_bank_account_attributes_name',   with: bank_account.name
      fill_in 'person_bank_account_attributes_number', with: bank_account.number
      fill_in 'person_bank_account_attributes_city',   with: bank_account.city
      check 'person_bank_account_attributes_allow_collection'

      click_button "Update Basic details"

      p = Person.last
      p.should have_bank_account
      p.bank_account.name.should   == bank_account.name
      p.bank_account.number.should == bank_account.number
      p.bank_account.city.should   == bank_account.city
      p.bank_account.allow_collection.should == true
    end

    it "creates a new partner" do
      person = create(:person_parent)
      visit edit_person_path(person)

      choose 'person_single_false'

      fill_in 'person_person_partnership_attributes_partner_attributes_initials', with: person3.initials
      fill_in 'person_person_partnership_attributes_partner_attributes_first_name', with: person3.first_name
      fill_in 'person_person_partnership_attributes_partner_attributes_surname', with: person3.surname

      click_button "Update Basic details"

      person.reload
      partner = person.partner

      partner.first_name.should == person3.first_name
      partner.surname.should == person3.surname
    end

    it "updates partner correctly" do
      person_with_partner = create(:person_with_partner)
      visit edit_person_path(person_with_partner)

      fill_in 'person_first_name', with: person2.first_name
      fill_in 'person_surname', with: person2.surname

      fill_in 'person_person_partnership_attributes_partner_attributes_first_name', with: person3.first_name
      fill_in 'person_person_partnership_attributes_partner_attributes_surname', with: person3.surname

      choose "person_has_parent_agreement_true"

      click_button "Update Basic details"

      person_with_partner.reload
      partner = person_with_partner.partner

      person_with_partner.first_name.should == person2.first_name
      person_with_partner.surname.should == person2.surname
      partner.first_name.should == person3.first_name
      partner.surname.should == person3.surname
    end

    it "destroys a partner if person is single", js: true do
      person_with_partner = create(:person_with_partner)
      visit edit_person_path(person_with_partner)
      choose 'person_single_true'
      click_button "Update Basic details"

      current_path.should eql(person_path(person_with_partner))
      person_with_partner.reload.partner.should == nil
    end

    it 'does not add empty partners' do
      expect {
        person = create(:person)
        visit edit_person_path(person)

        fill_in 'person_first_name', with: person2.first_name
        fill_in 'person_surname', with: person2.surname
        choose 'person_single_false'

        click_button "Update Basic details"
      }.to change(Person, :count).by(1)
    end

    it 'should allow invalid bank account number with easy to filter characters' do
      person = create(:person)
      visit edit_person_path(person)
      fill_in 'person_bank_account_attributes_number', with: 'P123.456.7'
      expect {
        click_button 'Update Basic details'
      }.to change { person.reload.bank_account.number }.to('P1234567')
    end

    it 'should not allow invalid bank account number' do
      visit edit_person_path(create(:person))
      fill_in 'person_bank_account_attributes_number', with: '124**a0'
      click_button 'Update Basic details'
      page.should have_content('NumberIs not valid bank account')
    end
  end

  context "destroy" do
    it "should delete the person" do
      person = create(:person_parent)

      expect {
        visit people_path(person_status: 'all')

        within("#person_#{person.id}") do
          click_link "Delete"
        end
      }.to change(Person, :count).by(-1)

      current_path.should eql(people_path)
      page.should have_content("Person deleted successfully.")
    end

    it "should delete the person and the partner" do
      person_with_partner = create(:person_with_partner)
      expect {
        visit people_path(person_status: 'all')
        within("#person_#{person_with_partner.id}") do
          click_link "Delete"
        end
      }.to change(Person, :count).by(-2)
    end

    context 'with dossier' do
      let!(:person){ create(:person_with_dossiers) }

      it 'should not remove person' do
        expect {
          visit people_path(person_status: 'all')
          within("#person_#{person.id}") do
            click_link "Delete"
          end
        }.to_not change(Person, :count)
      end

      it 'should not remove person' do
        visit people_path(person_status: 'all')
        within("#person_#{person.id}") do
          click_link "Delete"
        end
        page.should have_content('Unsuccessful. Only person without dossier can be removed')
      end
    end

  end

  context 'as franchisee manager' do
    let!(:franchisee) { create :franchisee }
    let!(:franchisee_manager) { create :user, franchisee: franchisee, full_name: "Frank Franchisee" }
    let!(:parent) { create :parent, franchisee: franchisee }

    before do
      sign_out
      sign_in_as(franchisee_manager)
    end

    context "when viewing a person" do
      it "should be able to download a signed agreement" do
        visit customer_detail_path(parent, page_detail: 'parent_agreement')
        click_link('Upload Signed Parent Contract')
        fill_in "Signed at", with: Date.today
        attach_file "Agreement", Rails.root.join('spec','fixtures','files','test.jpg')
        click_on "Update"
        click_link "Download"

        page.should_not have_content("403 Forbidden")
      end
    end

    context "user adoption" do
      let!(:employee) { create(:user) }
      let!(:person) { create :person, user: employee, franchisee: franchisee, email: "eddy.employee@viaviela.nl", first_name: "Eddy", surname_prefix: "de", surname: "Employee" }

      it "should be possible to adopt an user" do
        sign_out
        sign_in_as(franchisee_manager)
        visit person_path(person)
        page.should have_button t("adopt")

        click_button t("adopt")
        page.should have_content("Eddy de Employee")
        page.should_not have_content("Frank Franchisee")
        within(".adoption_alert") do
          page.should have_content("Attention: You are now logged in as user #{person.full_name}! Return to my own account")
        end

        click_link t("header.abandon")
        page.should have_content("Frank Franchisee")
        page.should_not have_content("Eddy de Employee")
      end
    end

  end
end
=end  $max_jokers = 40
