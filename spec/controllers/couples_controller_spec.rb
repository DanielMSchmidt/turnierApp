require 'spec_helper'
include Devise::TestHelpers

describe CouplesController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:woman) { FactoryGirl.create(:woman) }
  let!(:club) { FactoryGirl.create(:club) }
  let!(:couple) { FactoryGirl.create(:couple) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:tournament) { FactoryGirl.create(:tournament) }

  describe "#change" do
    before(:each) do
      sign_in user
    end
    it "should destroy the couple if remove is set" do
      Couple.should_receive(:find).with('42').and_return(couple)
      couple.should_receive(:consistsOfCurrentUser).with(user).and_return(true)
      couple.should_receive(:destroy)

      get :change, {id: 42, remove: true}
    end

    it "should not destroy the couple if remove is not set" do
      Couple.stub(:find).and_return(couple)
      couple.stub(:consistsOfCurrentUser).and_return(true)
      couple.should_not_receive(:destroy)

      get :change, {couple: {man: user.id, woman: 42, latin_kind: 'C', standard_kind: 'D'}}
    end

    it "should not destroy the couple doesnt consist of user" do
      Couple.stub(:find).and_return(couple)
      couple.should_receive(:consistsOfCurrentUser).with(user).and_return(false)
      couple.should_not_receive(:destroy)

      get :change, {id: 42, remove: true}
    end

    it "should not change the couple if it doesn't consist of user" do
      Couple.should_receive(:createFromParams).and_raise(DoesntConsistOfUser)
      couple.should_not_receive(:activate)

      get :change, {couple: {man: 32, woman: 42, latin_kind: 'C', standard_kind: 'D'}}
    end

    it "should create two progresses on couple change" do
      Couple.should_receive(:createFromParams).and_return(couple)

      get :change, {couple: {man: user.id, woman: 42, latin_kind: 'C', standard_kind: 'B'}}
    end
  end

  describe "#levelup" do
    before(:each) do
      sign_in user
      user.should_receive(:activeCouple).and_return(couple)
      @progress = double('Progress', levelUp: true)
    end

    it "should be able to levelup standard"
    it "should be able to levelup latin"
  end

  describe "#reset" do
  end

  describe "#printPlanning" do
  end
end
