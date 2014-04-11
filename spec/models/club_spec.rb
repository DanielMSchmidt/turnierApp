# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Club do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:couple){ FactoryGirl.create(:couple) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:club){ FactoryGirl.create(:club) }
  let!(:tournament){ FactoryGirl.create(:tournament) }
  let(:stubbed_tournament){ double('stubbed tournament') }

  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      it "should be true if the tournament is in the near future and unenrolled" do
        club.should_receive(:tournaments).at_least(1).times.and_return([stubbed_tournament])
        stubbed_tournament.stub(:shouldSendANotificationMail?).and_return(true)
        club.unenrolledAndEnrollableTournamentsLeftWhichShouldBeNotified.should be_true
      end

      it "should be false if the tournament is in the wide future and unenrolled", slow: true do
        FactoryGirl.create(:tournament, date: (DateTime.now.beginning_of_day.to_date + 2.months).to_date)
        club.unenrolledAndEnrollableTournamentsLeftWhichShouldBeNotified.should be_false
      end
    end
  end

  describe "the factories should work" do
    it "should be the right user" do
      user.name.should eq('Test User')
      user.email.should eq('test@testuser.de')
    end

    it "should have a couple" do
      user.activeCouple.should_not be_nil
    end

    it "should habe the right progresses" do
      couple = user.activeCouple
      couple.latin.should_not be_nil
      couple.standard.should_not be_nil
    end
  end

  describe "#isVerifiedUser" do
    it "should be false if the user is not verified" do
      club.should_receive(:verifiedCouples).and_return([])
      club.isVerifiedUser(user).should be_false
    end

    it "should be true if the user is verified" do
      couple = double('couple', users: [user], active: true)
      club.should_receive(:verifiedCouples).and_return([couple])
      club.isVerifiedUser(user).should be_true
    end
  end

  describe "#results" do
    before(:each) do
      @t1 = Time.now - 1.week
      @t2 = Time.now + 1.week
      @t3 = Time.now - 1.day
      @tmnt1 = double('tmnt1', points: 15, placing: 1, date: @t1)
      @tmnt2 = double('tmnt2', points: 5, placing: 0, date: @t2)

      club.stub(:tournaments).and_return([@tmnt1, @tmnt2])
    end

    it "should return right results if all tournaments are in range" do
      club.results(@t1, @t2).should eq({points: 20, placings: 1})
    end

    it "should return right results if not all tournaments are in range" do
      club.results(@t1, @t3).should eq({points: 15, placings: 1})
    end
  end
end
