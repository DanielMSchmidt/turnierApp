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
end