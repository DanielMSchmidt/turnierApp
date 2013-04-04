require 'spec_helper'
require 'capybara/rails'

describe Couple do
  let(:couple) { FactoryGirl.create(:couple) }


  describe "structure" do
    it { should belong_to(:user) }
    it { should have_many(:progresses) }
    it { should respond_to(:active) }
  end

  describe "interaction with" do
    describe "progresses" do
      describe "should have always two progresses" do
        it "should on creation generate two new progresses" do
          new_couple = FactoryGirl.create(:couple)
          new_couple.progresses.count.should eq(2)
        end
        it "should finish the std progress if another std progress is created" do
          std = couple.standard
          std.finished = true
          std.save
          couple.progresses.count.should eq(2)
          couple.standard.finished.should be_false
        end
        it "should finish the lat progress if another lat progress is created" do
          lat = couple.latin
          lat.finished = true
          lat.save
          couple.progresses.count.should eq(2)
          couple.latin.finished.should be_false
        end
      end
    end
  end

  describe "functions" do
    it { should respond_to(:latin, :standard) }
  end
end