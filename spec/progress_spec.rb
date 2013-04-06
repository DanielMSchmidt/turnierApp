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

        tournament1.should_receive(:placing).and_return(1)
        tournament2.should_receive(:placing).and_return(0)
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
  end
end