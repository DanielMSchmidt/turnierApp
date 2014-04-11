# -*- encoding : utf-8 -*-
require "spec_helper"

describe TournamentsHelper, :type => :helper do
  before(:each) do
    @time_now = DateTime.now
    DateTime.stub(:now).and_return(@time_now)
    @tournament1 = double("tournament1", upcoming?: false, date: @time_now)
    @tournament2 = double("tournament2", upcoming?: false, date: @time_now + 1.week)
  end

  describe "#getProgressOverTimeData" do

    it "should call mergeProgressArrays" do
      helper.stub(:getProgressOverTime).and_return([])

      helper.getProgressOverTimeData(double("couple", latin: [], standard: []))
    end
  end

  describe "#getProgressOverTime" do
    before(:each) do
      @progress = double("progress", tournaments: [@tournament1, @tournament2], pointsAtTime: 42, placingsAtTime: 23)
      @result = helper.getProgressOverTime(@progress, @progress)
    end
  end

  describe "#getTournamentsData" do
    before(:each) do
      latin_progress = double("LAT - progress", dancedTournaments: [@tournament1, @tournament2])
      standard_progess = double("STD - progress", dancedTournaments: [@tournament1])
      couple = double("couple", latin: latin_progress, standard: standard_progess)
      @result = helper.getTournamentsData(couple)
    end

    it "should return an array with one hash" do
      @result.should be_an Array
      @result.length.should eq(1)
      @result.first.should be_a Hash
    end

    it "should have the right attributes in the hash" do
      @result.first.should have_key(:y)
      @result.first.should have_key(:l)
      @result.first.should have_key(:s)
    end

    it "should have all latin tournaments counted" do
      @result.first[:l].should eq(2)
    end

    it "should have all standard tournaments counted" do
      @result.first[:s].should eq(1)
    end
  end

  describe "#getPlacingsData" do
    before(:each) do
      latin_progress = double("LAT - progress", placings: 1)
      standard_progess = double("STD - progress", placings: 0)

      couple = double("couple", latin: latin_progress, standard: standard_progess)
      @result = helper.getPlacingsData(couple)
    end

    it "should return an array with one hash" do
      @result.should be_an Array
      @result.length.should eq(1)
      @result.first.should be_a Hash
    end

    it "should have the right attributes in the hash" do
      @result.first.should have_key(:y)
      @result.first.should have_key(:l)
      @result.first.should have_key(:s)
    end

    it "should have the right placing count for latin" do
      @result.first[:l].should eq(1)
    end

    it "should have the right placing count for standard" do
      @result.first[:s].should eq(0)
    end
  end

  describe "#getPointsData" do
    before(:each) do
      latin_progress = double("LAT - progress", points: 8)
      standard_progess = double("STD - progress", points: 5)
      couple = double("couple", latin: latin_progress, standard: standard_progess)
      @result = helper.getPointsData(couple)
    end

    it "should return an array with one hash" do
      @result.should be_an Array
      @result.length.should eq(1)
      @result.first.should be_a Hash
    end

    it "should have the right attributes in the hash" do
      @result.first.should have_key(:y)
      @result.first.should have_key(:l)
      @result.first.should have_key(:s)
    end

    it "should have the right points count for standard" do
      @result.first[:l].should eq(8)
    end

    it "should have the right points count for standard" do
      @result.first[:s].should eq(5)
    end
  end
end
