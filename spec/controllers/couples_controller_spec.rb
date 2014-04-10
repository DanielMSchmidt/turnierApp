require 'spec_helper'
include Devise::TestHelpers

describe CouplesController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:club) { FactoryGirl.create(:club) }
  let!(:couple) { FactoryGirl.create(:couple) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:tournament) { FactoryGirl.create(:tournament) }

  before(:each) do
    sign_in user
  end

  describe "#change" do
    it "should destroy the couple if remove is set" do
      Couple.should_receive(:find).with('42').and_return(couple)
      couple.should_receive(:destroy)

      get :change, {id: 42, remove: true}
    end

    it "should not destroy the couple if remove is not set" do
      Couple.stub(:find).and_return(couple)
      couple.should_not_receive(:destroy)

      get :change, {couple: {man: user.id, woman: 42, latin_kind: 'C', standard_kind: 'D'}}
    end

    it "should not destroy the couple doesnt consist of user" do
      Couple.stub(:find).and_return(couple)
      couple.should_not_receive(:destroy)

      get :change, {id: 42, remove: true}
    end

    it "should not change the couple if it doesn't consist of user" do
      Couple.should_receive(:createFromParams).and_return(couple)
      couple.should_not_receive(:activate)

      get :change, {couple: {man: 32, woman: 42, latin_kind: 'C', standard_kind: 'D'}}
    end

    it "should create two progresses on couple change" do
      Couple.should_receive(:createFromParams).and_return(couple)
      couple.should_not_receive(:activate)
      couple.standard.start_class.should eq('D')
      couple.latin.start_class.should eq('C')

      couple.standard.saved?.should be_true
      couple.latin.saved?.should be_true


      get :change, {couple: {man: user.id, woman: 42, latin_kind: 'C', standard_kind: 'D'}}
    end

  end

  describe "#levelup" do
  end

  describe "#reset" do
  end

  describe "#printPlanning" do
  end
end
