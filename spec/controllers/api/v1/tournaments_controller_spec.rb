require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::TournamentsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:woman) { FactoryGirl.create(:woman) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  render_views


  before(:each) do
    allow(controller).to receive(:sign_in)
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:partner).and_return(woman)

    authWithUser(user)
  end

  describe "#index" do
    it "should give back all user tournaments" do
      user.should_receive(:torunament).and_return([])

      get :index
    end

    it "every tournament should containt number, status, points and placings" do
      user.stub(:tournament).and_return([tournament])
      get :index

      expect(json[0]['number']).to eq(tournament.number)
      expect(json[0]['placings']).to eq(tournament.placings)
      expect(json[0]['points']).to eq(tournament.points)
      expect(json[0]['status']).to eq(tournament.status)
    end

    it "every tournament should containt address and time" do
      user.stub(:tournament).and_return([tournament])
      get :index

      expect(json[0]['address']).to eq(tournament.address)
      expect(json[0]['date']).to eq(tournament.date)
      expect(json[0]['kind']).to eq(tournament.kind)
    end
  end

  describe "#create" do
    it "should create a torunament with right params"
    it "should not create a tournament with missing information"
  end

  describe "#update" do
    it "should update the right tournament"
  end

  describe "#destroy" do
    it "should destroy the right torunament"
  end
end