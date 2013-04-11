require "spec_helper"

describe TournamentsHelper, :type => :helper do
  before(:each) do
    @time_now = DateTime.now
    DateTime.stub(:now).and_return(@time_now)
  end

  describe "#getProgressOverTimeData" do

    it "should call mergeProgressArrays" do
      helper.stub(:getProgressOverTime).and_return([])
      helper.should_receive(:mergeProgressArrays).and_return([])

      helper.getProgressOverTimeData(double("couple", latin: [], standard: []))
    end

    it "should call getProgressOverTime twice" do
      helper.should_receive(:getProgressOverTime).twice
      helper.stub(:mergeProgressArrays)

      helper.getProgressOverTimeData(double("couple", latin: [], standard: []))
    end
  end

  describe "#mergeProgressArrays" do
    it "should return a sorted array" do
      result1 = helper.mergeProgressArrays([{y: DateTime.now}], [{y: DateTime.now + 2.weeks}])
      result2 = helper.mergeProgressArrays([{y: DateTime.now + 2.weeks}], [{y: DateTime.now}])
      right_result = [{y: DateTime.now}, {y: DateTime.now + 2.weeks}]

      result1.first[:y].day.should eq(right_result.first[:y].day)
      result2.first[:y].day.should eq(right_result.first[:y].day)
    end

    it "should have elements from the first array in that array" do
      result = helper.mergeProgressArrays([{y: DateTime.now, points: 42}], [{y: DateTime.now + 2.weeks, points: 23}])
      result.select{|x| x[:points] == 42}.length.should eq(1)
    end

    it "should have elements from the second in that array" do
      result = helper.mergeProgressArrays([{y: DateTime.now, points: 42}], [{y: DateTime.now + 2.weeks, points: 23}])
      result.select{|x| x[:points] == 23}.length.should eq(1)
    end
  end

  describe "#getProgressOverTime" do
    before(:each) do
      @tournament1 = double("tournament1", upcoming?: false, date: @time_now)
      @tournament2 = double("tournament2", upcoming?: false, date: @time_now + 1.week)
      @progress = double("progress", tournaments: [@tournament1, @tournament2], points_at_time: 42, placings_at_time: 23)
      @result = helper.getProgressOverTime(@progress)
    end

    it "should return an array of hashes" do
      @result.should be_an Array
      @result.first.should be_a Hash
    end

    it "should have an element in the array for each tournament" do
      @result.size.should eq(@progress.tournaments.size)
    end

    it "should have right formatted hashes as elements" do
      hash = @result.first
      hash.should have_key(:y)
      hash.should have_key(:po)
      hash.should have_key(:pl)
    end

    it "should filter upcoming tournaments" do
      tournament3 =  double("tournament1", upcoming?: true, date: @time_now + 3.weeks)
      progress2 = double("progress", tournaments: [@tournament1, @tournament2, tournament3], points_at_time: 42, placings_at_time: 23)

      helper.getProgressOverTime(progress2).size.should eq(2)
    end
  end
end