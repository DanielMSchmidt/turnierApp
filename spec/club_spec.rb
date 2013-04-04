require 'spec_helper'
require 'capybara/rails'

describe Club do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:club){ FactoryGirl.create(:club) }
  let(:tournament){ FactoryGirl.create(:tournament) }

  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      it "should be true if the tournament is in the near future and unenrolled" do
        tournament
        club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified.should be_true
      end

      it "should be false if the tournament is in the wide future and unenrolled" do
        FactoryGirl.create(:tournament, date: (DateTime.now.beginning_of_day.to_date + 2.months).to_date)
        club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified.should be_false
      end
    end
  end
  describe "the factories should work" do
    it "should be the right user" do
      assert_equal(user.name, 'Test User')
      assert_equal(user.email, 'test@testuser.de')
    end

    it "should be the right tournament" do
      assert_equal(tournament.number, 28288)
      assert_equal(tournament, user.tournaments.first)
    end

    it "should be the right club" do
      assert_equal(club.name, 'Example Club')
      assert_equal(club.owner, user)
    end

    it "should be the right membership" do
      assert_equal(user.clubs.first, club)
    end
  end
end