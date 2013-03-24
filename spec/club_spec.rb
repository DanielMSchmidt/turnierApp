require 'spec_helper'
require 'capybara/rails'

describe "Club" do
  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      before(:each) do
        @user ||= FactoryGirl.create(:user)
        @club ||= FactoryGirl.create(:club)
        FactoryGirl.create(:membership)
      end

      it "should be true if the tournament is in the near future and unenrolled" do
        FactoryGirl.create(:tournament)

        assert(@club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified)
      end

      it "should be false if the tournament is in the wide future and unenrolled" do
        FactoryGirl.create(:tournament, date: (DateTime.now + 2.months).to_date)

        assert(!@club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified)
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
  end
end