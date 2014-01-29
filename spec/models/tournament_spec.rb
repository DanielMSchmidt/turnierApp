# -*- encoding : utf-8 -*-
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

  describe "#newForUser" do
    it "should be able to create a simple tournament", slow: true do
      tournament = Tournament.newForUser({tournament: {number: 31193, user_id: 1}})
      tournament.number.should eq(31193)
      tournament.date.should eq("2013-05-19 18:30:00")
      tournament.kind.should eq("HGR B ST")
      tournament.notes.should eq("Startgebühr für HGR je 5,- €/Paar")
      tournament.enrolled.should be_false
    end

    it "should be able to create an advanced tournament", slow: true do
      tournament = Tournament.newForUser({tournament: {number: 28948, user_id: 1}})
      tournament.number.should eq(28948)
      tournament.date.should eq("Sun, 10 Mar 2013 11:00:00 UTC +00:00")
      tournament.kind.should eq("HGR C LAT")
      tournament.notes.should eq("Startgebühr je 5,- €/Paar")
      tournament.enrolled.should be_true
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
end
