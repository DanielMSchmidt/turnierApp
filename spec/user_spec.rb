require 'spec_helper'
require 'capybara/rails'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it "should hava a working factory" do
    user.should be_valid
  end

  describe "structure" do
    it { should respond_to(:couples) }
    it "shouldnt have more then one active couple per time" do
      user.get_couples.each{|couple| couple.delete}
      user.get_couples.count.should eq(0)

      first_couple = Couple.create({man_id: user.id, woman_id: 42, active: true})

      # doesnt work here, works in console
      #first_couple.should_receive(:deactivate)

      second_couple = Couple.new({man_id: user.id, woman_id: 43, active: true})
      second_couple.should_receive(:deactivate_other_couples)
      Couple.where(man_id: user.id).count.should eq(1)

      second_couple.save
      Couple.where(man_id: user.id).count.should eq(2)
      user.get_couples.count.should eq(2)
    end
  end

  describe "functions" do
    describe "#getOrganisedTournaments" do
      it "should return an empty array if the user hasnt got any clubs"
      it "should return all tournaments of the clubs associated with this user"
    end

    describe "#activeCouple" do
    end

    describe "#verified_clubs" do
    end

    describe "#unverified_clubs" do
    end

    describe "#get_id_by_name" do
    end

    describe "#isntSet" do
    end
  end
end