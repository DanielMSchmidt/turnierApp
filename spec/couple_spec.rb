require 'spec_helper'
require 'capybara/rails'

describe Couple do
  subject(:couple) { FactoryGirl.create(:couple) }


  describe "structure" do
    it "should have a man assigned" do
      couple.should respond_to(:man)
    end

    it "should have a woman assigned" do
      couple.should respond_to(:woman)
    end

    it "should have many progresses" do
      couple.should respond_to(:progresses)
    end

    it { should respond_to(:active) }
  end

  describe "interaction with" do
    describe "progresses" do
      describe "should have always two progresses" do
        it "should on creation generate two new progresses" do
          couple.progresses.count.should eq(2)
        end
        it "should finish the std progress if another std progress is created" do
          pending "write new with new method"
          std = couple.standard.create_new(params)
        end
        it "should finish the lat progress if another lat progress is created" do
          pending "write new with new method"
          lat = couple.latin.create_new(params)
        end
      end
    end
  end

  describe "functions" do
    it { should respond_to(:latin, :standard) }
  end
end