# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'capybara/rails'

describe Progress do
  let(:progress) { FactoryGirl.create(:progress) }

  describe "structure" do

    it "should belong to a couple" do
      progress.should respond_to(:couple)
    end

    it "should have many tournaments" do
      progress.should respond_to(:tournaments)
    end

    it{ should respond_to(:kind) }
    it{ should respond_to(:start_points) }
    it{ should respond_to(:start_placings) }
    it{ should respond_to(:start_class) }
    it{ should respond_to(:finished) }

    describe "shouldnt be able to have another kind then standard or latin" do
      it "should be possible to assign latin" do
        progress.kind = 'latin'
        progress.save.should eq(true)
      end
      it "should be possible to assign standard" do
        progress.kind = 'standard'
        progress.save.should eq(true)
      end
      it "shouldn't be possible to assign test" do
        progress.kind = 'test'
        progress.save.should eq(false)
      end
    end
  end

  describe "functions" do
    describe "should be able to calculate the placings" do
      it { should respond_to(:placings) }
      it "should calculate the placings right" do
        tournament1 = double("tournament1")
        tournament2 = double("tournament2")
        all_tournaments = [tournament1, tournament2]

        tournament1.should_receive(:placings).and_return(1)
        tournament2.should_receive(:placings).and_return(0)
        progress.should_receive(:tournaments).and_return(all_tournaments)
        progress.should_receive(:start_placings).and_return(1)

        progress.placings.should eq(2)
      end
    end
    describe "should be able to calculate the points" do
      it { should respond_to(:points) }
      it "should calculate the placings right" do
        tournament1 = double("tournament1")
        tournament2 = double("tournament2")
        all_tournaments = [tournament1, tournament2]

        tournament1.should_receive(:points).and_return(10)
        tournament2.should_receive(:points).and_return(2)
        progress.should_receive(:tournaments).and_return(all_tournaments)
        progress.should_receive(:start_points).and_return(5)

        progress.points.should eq(17)
      end
    end

    describe "#reset" do
      it "should create a new Progress" do
        progress
        expect{progress.reset}.to change{Progress.count}.by(1)
      end

      it "should have the same class as before" do
        progress.reset.start_class.should eq(progress.start_class)
      end
    end

    describe "#levelUp" do
      it "should create a new Progress" do
        progress
        expect{progress.levelUp}.to change{Progress.count}.by(1)
      end

      it "should have the next class as before" do
        progress.levelUp.start_class.should eq(progress.nextClass)
      end
    end

    describe "#nextClass" do
      it "should return C for D" do
        progress.start_class = 'D'
        progress.nextClass.should eq('C')
      end

      it "should return B for C" do
        progress.start_class = 'C'
        progress.nextClass.should eq('B')
      end

      it "should return A for B" do
        progress.start_class = 'B'
        progress.nextClass.should eq('A')
      end

      it "should return S for A" do
        progress.start_class = 'A'
        progress.nextClass.should eq('S')
      end

      it "should return S for S" do
        progress.start_class = 'S'
        progress.nextClass.should eq('S')
      end
    end

    describe "#maxPointsOfClass" do
      it "should be 100 if D Class" do
        progress.stub(:start_class).and_return('D')
        progress.maxPointsOfClass.should eq(100)
      end

      it "should be 150 if C Class" do
        progress.stub(:start_class).and_return('C')
        progress.maxPointsOfClass.should eq(150)
      end

      it "should be 200 if B Class" do
        progress.stub(:start_class).and_return('B')
        progress.maxPointsOfClass.should eq(200)
      end

      it "should be 250 if A Class" do
        progress.stub(:start_class).and_return('A')
        progress.maxPointsOfClass.should eq(250)
      end
    end

    describe "#maxPlacingsOfClass" do
      it "should be 7 if D Class" do
        progress.stub(:start_class).and_return('D')
        progress.maxPlacingsOfClass.should eq(7)
      end

      it "should be 7 if C Class" do
        progress.stub(:start_class).and_return('C')
        progress.maxPlacingsOfClass.should eq(7)
      end

      it "should be 7 if B Class" do
        progress.stub(:start_class).and_return('B')
        progress.maxPlacingsOfClass.should eq(7)
      end

      it "should be 10 if A Class" do
        progress.stub(:start_class).and_return('A')
        progress.maxPlacingsOfClass.should eq(10)
      end
    end

    describe "#points_in_percentage" do
      it "should calculate 20% for 20 points in D class" do
        progress.stub(:start_class).and_return('D')
        progress.stub(:points).and_return(20)
        progress.points_in_percentage.should eq(20)
      end

      it "should calculate 20% for 30 points in C class" do
        progress.stub(:start_class).and_return('C')
        progress.stub(:points).and_return(30)
        progress.points_in_percentage.should eq(20)
      end

      it "should calculate 14% for 21 points in C class" do
        progress.stub(:start_class).and_return('C')
        progress.stub(:points).and_return(21)
        progress.points_in_percentage.should eq(14)
      end

      it "should calculate 100% for 121 points in C class" do
        progress.stub(:start_class).and_return('C')
        progress.stub(:points).and_return(171)
        progress.points_in_percentage.should eq(100)
      end
    end

    describe "#placings_in_percentage" do
      it "should calculate 42,85% for 3 placings in B class" do
        progress.stub(:start_class).and_return('B')
        progress.stub(:placings).and_return(3)
        progress.placings_in_percentage.should eq(42.86)
      end

      it "should calculate 30% for 3 placings in A class" do
        progress.stub(:start_class).and_return('A')
        progress.stub(:placings).and_return(3)
        progress.placings_in_percentage.should eq(30)
      end

      it "should calculate 50% for 5 placings in A class" do
        progress.stub(:start_class).and_return('A')
        progress.stub(:placings).and_return(5)
        progress.placings_in_percentage.should eq(50)
      end

      it "should calculate 100% for 12 placings in A class" do
        progress.stub(:start_class).and_return('A')
        progress.stub(:placings).and_return(12)
        progress.placings_in_percentage.should eq(100)
      end
    end

    describe "#points_at_time" do
      before(:each) do
        @date = DateTime.now
        @tm1 = double("tournament1", date: @date, points: 4)
        @tm2 = double("tournament2", date: @date - 1.week, points: 5)
        @tm3 = double("tournament3", date: @date + 1.week, points: 6)
        progress.stub(:tournaments).and_return([@tm1, @tm2, @tm3])
      end

      it "should be all tournaments included until this point of time" do
        @tm1.should_receive(:points)
        @tm2.should_receive(:points)

        progress.points_at_time(@date)
      end

      it "should be all tournaments excluded after this point of time" do
        @tm3.should_not_receive(:points)

        progress.points_at_time(@date)
      end

      it "should add all points until this point of time" do
        progress.points_at_time(@date).should eq(9)
      end
    end

    describe "#placings_at_time" do
      before(:each) do
        @date = DateTime.now
        @tm1 = double("tournament1", date: @date, placings: 4)
        @tm2 = double("tournament2", date: @date - 1.week, placings: 5)
        @tm3 = double("tournament3", date: @date + 1.week, placings: 6)
        progress.stub(:tournaments).and_return([@tm1, @tm2, @tm3])
      end

      it "should be all tournaments included until this point of time" do
        @tm1.should_receive(:placings)
        @tm2.should_receive(:placings)

        progress.placings_at_time(@date)
      end

      it "should be all tournaments excluded after this point of time" do
        @tm3.should_not_receive(:placings)

        progress.placings_at_time(@date)
      end

      it "should add all placings until this point of time" do
        progress.placings_at_time(@date).should eq(9)
      end
    end
  end
end
