require 'spec_helper'
require 'capybara/rails'

describe "Tournament" do
  let(:user) { FactoryGirl.create(:user) }
  let(:club) { FactoryGirl.create(:club) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let(:tournament) { FactoryGirl.create(:tournament) }

  describe "the status" do
    it "should be marked as missing if there is no data and its danced and enrolled" do
      tournament.enrolled = true
      tournament.participants = nil
      tournament.place = nil
      tournament.save!

      tournament.incomplete?.should be_true
    end

    it "should be marked as missing if there is no data and its danced and unenrolled" do
      tournament.enrolled = false
      tournament.participants = nil
      tournament.place = nil
      tournament.save!

      tournament.incomplete?.should be_true
    end

    it "should be marked as okay if its enrolled" do
      tournament.enrolled = true
      tournament.participants = nil
      tournament.place = nil
      tournament.save!

      tournament.is_enrolled_and_not_danced?.should be_true
    end
  end

  describe "the calculation" do
    before(:each) do
      tournament.place = 1
      tournament.participants = 10
    end
    it "should calculate placings right" do
      tournament.placing.should eq(1)
    end
    it "should calculate points right" do
      tournament.points.should eq(9)
    end
  end

  describe "#should_send_a_notification_mail?" do
    it "should be false if the tournament is enrolled" do
      enrolled_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 2.weeks), kind: 'HGR C LAT', enrolled: true)
      enrolled_tournament.should_send_a_notification_mail?.should be_false
    end
    it "should be false if the tournament is far away" do
      future_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 8.weeks), kind: 'HGR C LAT', enrolled: false)
      future_tournament.should_send_a_notification_mail?.should be_false
    end
    it "should be true if the tournament is near and unenrolled" do
      next_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 2.weeks), kind: 'HGR C LAT', enrolled: false)
      next_tournament.should_send_a_notification_mail?.should be_true
    end
  end
end