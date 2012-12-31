require 'spec_helper'
require 'capybara/rails'

describe "Club" do
  describe "creating a club" do

    it "should be a user assigned to the created club" do
      User.all.each{|x| x.delete}
      user = FactoryGirl.create(:user)

      visit "/users/sign_in"
      fill_in("user[email]", :with => user.email)
      fill_in("user[password]", :with => user.password)
      click_on("Anmelden")

      assert_equal(user, current_user, "user should be logged in")
    end
    it "should be a club created"
  end
  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      before(:each) do
        @user ||= FactoryGirl.create(:user)
        @club ||= FactoryGirl.create(:club)
        FactoryGirl.create(:membership)
      end

      it "should be true if the tournament is in the near future and unenrolled" do
        FactoryGirl.create(:tournament)

        assert(@club.unenrolled_and_enrollable_tournaments_left)
      end

      it "should be false if the tournament is in the wide future and unenrolled" do
        FactoryGirl.create(:tournament, date: (DateTime.now + 2.months).to_date)

        assert(!@club.unenrolled_and_enrollable_tournaments_left)
      end

      it "should be false if the tournament is in the near future and enrolled" do
        Tournament.all.each{|x| x.delete}
        FactoryGirl.create(:enrolled_tournament)

        assert_equal(Tournament.count, 1, 'there should only be one tournament')
        assert(!@club.unenrolled_and_enrollable_tournaments_left, 'got unenrolled and enrollable tournaments, where there should be none')
      end

    end
  end
  describe "the factories should work" do
    before(:each) do
      @user ||= FactoryGirl.create(:user)
      FactoryGirl.create(:membership)
    end
    it "should be the right user" do
      assert_equal(@user.name, 'Test User')
      assert_equal(@user.email, 'test@testuser.de')
    end

    it "should be the right tournament" do
      tournament = FactoryGirl.create(:tournament)

      assert_equal(tournament.number, 28288)
      assert_equal(tournament.date.to_date, DateTime.now.to_date + 2.weeks)
      assert_equal(tournament, @user.tournaments.first)
    end

    it "should be the right club" do
      club = FactoryGirl.create(:club)

      assert_equal(club.name, 'Example Club')
      assert_equal(club.owner, @user)
    end

    it "should be the right membership" do
      club = FactoryGirl.create(:club)
      FactoryGirl.create(:membership)

      assert_equal(@user.clubs.first, club)
    end
    it "should be able to have enrolled and unenrolled tournaments" do
      unenrolled = FactoryGirl.create(:tournament)
      enrolled = FactoryGirl.create(:enrolled_tournament)

      assert(enrolled.enrolled?)
      assert(!unenrolled.enrolled?)
    end
  end
end