require 'spec_helper'
require 'capybara/rails'

describe Progress do
  let(:progress) { FactoryGirl.create(:progress) }

  describe "structure" do
    it { should belong_to(:couple) }
    it { should have_many(:tournaments) }

    its(:kind){ should be_present }
    its(:start_points){ should be_present }
    its(:start_placings){ should be_present }
    its(:start_class){ should be_present }
    its(:finished){ should be_present }

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

        progress.placings.should eq(17)
      end
    end
  end
end