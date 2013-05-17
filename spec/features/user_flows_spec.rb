require 'spec_helper'

feature "UserFlows" do
  let!(:user) {FactoryGirl.create(:user)}
  #TODO: Add admin
  #let!(:admin) {FactoryGirl.create(:admin)}

  after(:each) do
    Warden.test_reset!
  end

  describe "root page" do
    it "should work" do
      visit '/'
      page.should have_content("TurnierApp? Was soll das?")
    end

    describe "dashboard functions" do
      before(:each) do
        login_as(user, :scope => :user)
      end

      it "shouldn't show the landing page" do
        visit '/'
        page.should_not have_content("TurnierApp? Was soll das?")
      end

      it "should show a line graph"
      it "should show three bar graphs"
      it "should show a menu bar"

      describe "error alerts" do
        it "should have an alert for a missing couple"
        it "should have an alert for missing data on an tournament"
        it "should have an alert for a missing club"
      end

      describe "menu bar" do
        it "should have a button for adding a partner"
        it "should have a button for adding a club"
        it "should have a button for adding a tournament"
      end

      describe "modals" do
        # TODO: Fill
      end
    end


    describe "dashboard switch" do
      before(:each) do
        login_as(admin, :scope => :user)
      end

      it "should be able to switch from user to admin"
      it "should be able to switch from admin to user"

      it "should have the possibility to change the club owner"
      it "should have the possibility to change the club club properties"
      it "should have a print upcoming tournaments button"
      it "should have a print results button"
    end
  end
end
