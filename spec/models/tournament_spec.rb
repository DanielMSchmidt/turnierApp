# -*- encoding : utf-8 -*-
require 'spec_helper'

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

      tournament.isEnrolledAndNotDanced?.should be_true
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

  describe "#shouldSendANotificationMail?" do
    it "should be false if the tournament is enrolled" do
      enrolled_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 2.weeks), kind: 'HGR C LAT', enrolled: true)
      enrolled_tournament.shouldSendANotificationMail?.should be_false
    end
    it "should be false if the tournament is far away" do
      future_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 8.weeks), kind: 'HGR C LAT', enrolled: false)
      future_tournament.shouldSendANotificationMail?.should be_false
    end
    it "should be true if the tournament is near and unenrolled" do
      next_tournament = Tournament.create(number: 28288, progress_id: 1, address: "testadress", date: (DateTime.now.beginning_of_day.to_date + 2.weeks), kind: 'HGR C LAT', enrolled: false)
      next_tournament.shouldSendANotificationMail?.should be_true
    end
  end

  describe "#statusClasses" do
    it "should have the behind time class if its behind time" do
      tournament.stub(:behindTime?).and_return(true)

      tournament.statusClasses.should eq('icons-missing_information')
    end

    it "should have the behind time class if its behind time, although its not enrolled" do
      tournament.stub(:behindTime?).and_return(true)
      tournament.stub(:enrolled?).and_return(false)

      tournament.statusClasses.should eq('icons-missing_information')
    end

    it "should have the not enrolled class if its not enrolled" do
      tournament.stub(:behindTime?).and_return(false)
      tournament.stub(:enrolled?).and_return(false)

      tournament.statusClasses.should eq('icons-not_enrolled')
    end

    it "should be have the ok class if everything is ok" do
      tournament.stub(:behindTime?).and_return(false)
      tournament.stub(:enrolled?).and_return(true)

      tournament.statusClasses.should eq('icons-ok')
    end
  end
  describe "startclass should calculate right" do
    it "should be D for HGR D STD" do
      tournament.stub(:kind).and_return('HGR D STD')
      tournament.start_class.should eq('D')
    end
    it "should be C for Sen IV C LAT" do
      tournament.stub(:kind).and_return('Sen IV C LAT')
      tournament.start_class.should eq('C')
    end
    it "should be B for JUN II B LAT" do
      tournament.stub(:kind).and_return('JUN II B LAT')
      tournament.start_class.should eq('B')
    end
    it "should be A for HGR II A ST" do
      tournament.stub(:kind).and_return('HGR II A ST')
      tournament.start_class.should eq('A')
    end
  end

  describe "#status" do
    it "should be fetching if wasnt fetched yet" do
      tournament.stub(:fetched).and_return(false)

      expect(tournament.status).to eq(:fetching)
    end

    it "should be unenrolled if not enrolled and not done" do
      tournament.stub(:fetched).and_return(true)
      tournament.stub(:enrolled).and_return(false)
      tournament.stub(:date).and_return(Date.today + 1.week)

      expect(tournament.status).to eq(:unenrolled)
    end

    it "should be enrolled if enrolled and not done" do
      tournament.stub(:fetched).and_return(true)
      tournament.stub(:enrolled?).and_return(true)
      tournament.stub(:date).and_return(Date.today + 1.week)

      expect(tournament.status).to eq(:enrolled)
    end


    it "should be incomplete if it has happened and there is information" do
      tournament.stub(:fetched).and_return(true)
      tournament.stub(:date).and_return(Date.today - 1.week)
      tournament.stub(:place).and_return(nil)
      tournament.stub(:participants).and_return(nil)

      expect(tournament.status).to eq(:incomplete)
    end

    it "should be done if it has happened and there is information" do
      tournament.stub(:fetched).and_return(true)
      tournament.stub(:date).and_return(Date.today - 1.week)
      tournament.stub(:place).and_return(1)
      tournament.stub(:participants).and_return(3)

      expect(tournament.status).to eq(:done)
    end
  end
end
