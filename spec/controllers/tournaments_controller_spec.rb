require 'spec_helper'
include Devise::TestHelpers

describe TournamentsController do
  let!(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user
  end


  describe "#create" do
    it "should redirect and create a new one" do
      params = {"tournament"=>{}, "controller"=>"tournaments", "action"=>"create"}
      Tournament.should_receive(:newForUser).with(params).and_return(double('Tournament', valid?: true))

      post :create, {tournament: {}}

      assert_response :redirect
    end
  end

  describe "#update" do
    it "should redirect and update" do
      tournament = double('Tournament')
      tournament.should_receive(:update_attributes).with({}).and_return(true)
      Tournament.should_receive(:find).with("42").and_return(tournament)

      put :update, id: 42, tournament: {}

      assert_response :redirect
    end
  end

  describe "#setAsEnrolled" do
    it "should redirect and set enrolled as true" do
      tournament = double('Tournament')
      tournament.should_receive(:update_column).with(:enrolled, true).and_return(true)
      Tournament.should_receive(:find).with("42").and_return(tournament)

      get :setAsEnrolled, id: 42

      assert_response :redirect
    end
  end

  describe "#destroy" do
    it "should redirect and destroy" do
      tournament = double('Tournament')
      tournament.should_receive(:destroy)
      Tournament.should_receive(:find).with("42").and_return(tournament)

      get :destroy, id: 42

      assert_response :redirect
    end
  end

  describe "#canBeAdministratedBy" do
    it "should return true if the club of this tournament is owned by the user"
    it "should return false if not"
  end
end
