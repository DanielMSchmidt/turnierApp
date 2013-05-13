# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'capybara/rails'

describe Club do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:couple){ FactoryGirl.create(:couple) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:club){ FactoryGirl.create(:club) }
  let!(:tournament){ FactoryGirl.create(:tournament) }
  let(:stubbed_tournament){ double('stubbed tournament') }

  describe "#mail_owner_unenrolled_tournaments" do
    it "should send the unenrolled tournaments to the owner", slow: true do
      NotificationMailer.should_receive(:enrollCouples).and_return(double('mail', deliver: true))
      club.should_receive(:unenrolled_and_enrollable_tournaments_left_which_should_be_notified).and_return(true)
      club.mail_owner_unenrolled_tournaments
    end
  end

  describe "sending of unenrollment mails" do
    describe "method unenrolled_and_enrollable_tournaments_left" do
      it "should be true if the tournament is in the near future and unenrolled" do
        club.should_receive(:tournaments).at_least(1).times.and_return([stubbed_tournament])
        stubbed_tournament.stub(:should_send_a_notification_mail?).and_return(true)
        club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified.should be_true
      end

      it "should be false if the tournament is in the wide future and unenrolled", slow: true do
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

    it "should have a couple" do
      user.activeCouple.should_not be_nil
    end

    it "should habe the right progresses" do
      couple = user.activeCouple
      couple.latin.should_not be_nil
      couple.standard.should_not be_nil
    end

    it "should be the right club" do
      club.name.should eq('Example Club')
      club.owner.id.should eq(user.id)
    end

    it "should be the right membership" do
      user.clubs.first.id.should eq(club.id)
    end
  end

  describe "#is_owner?" do
    it "should be true if user is owner" do
      club.user_id = user.id
      club.is_owner?(user).should be_true
    end

    it "should be false if user isn't owner" do
      club.user_id = 10
      club.is_owner?(user).should be_false
    end

    it "should be false if user is nil" do
      club.is_owner?(nil).should be_false
    end
  end

  describe "#transfer_to" do
    it "it should change the owner" do
      club.user_id = 10
      club.owner.should be_nil

      club.transfer_to(user)
      club.owner.id.should eq(user.id)
    end
  end

  describe "#is_verified_member" do
    it "should be false if the user is not verified" do
      club.should_receive(:verified_members).and_return([])
      club.is_verified_member(user).should be_false
    end
    it "should be true if the user is verified" do
      club.should_receive(:verified_members).and_return([user])
      club.is_verified_member(user).should be_true
    end
  end
end
