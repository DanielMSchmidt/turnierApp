require 'spec_helper'
require 'capybara/rails'

describe Club do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:club){ FactoryGirl.create(:club) }
  let!(:tournament){ FactoryGirl.create(:tournament) }
  let(:stubbed_tournament){ double('stubbed tournament') }

  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      it "should be true if the tournament is in the near future and unenrolled" do
        club.should_receive(:tournaments).at_least(1).times.and_return([stubbed_tournament])
        stubbed_tournament.stub(:should_send_a_notification_mail?).and_return(true)
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
      user.name.should eq('Test User')
      user.email.should eq('test@testuser.de')
    end

    it "should be the right tournament" do
      tournament.number.should eq(28288)
      user.tournaments.first.id.should eq(tournament.id)
    end

    it "should be the right club" do
      club.name.should eq('Example Club')
      club.owner.id.should eq(user.id)
    end

    it "should be the right membership" do
      user.clubs.first.id.should eq(club.id)
    end
  end
end