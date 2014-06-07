require 'spec_helper'
include Devise::TestHelpers

describe HomeController do
  let!(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user
  end

  describe "#index" do
    it "should succeed" do
      get :index

      assert_response :success
    end

    it "should succeed if it's owned" do
      @clubs = [double('owned Club', verifiedCouples: [], unverifiedCouples: [], id: 1)]
      Club.stub(:ownedBy).and_return(@clubs)

      get :index

      assert_response :success
    end

    it "should succeed if it's not owned" do
      Club.stub(:ownedBy).and_return([])

      get :index

      assert_response :success
    end
  end

  describe "#admin" do
    it "should succeed" do
      @clubs = [double('owned Club', verifiedCouples: [], unverifiedCouples: [], id: 4)]
      Club.stub(:ownedBy).and_return(@clubs)

      get :admin, club_id: 4

      assert_response :success
    end
  end
end
