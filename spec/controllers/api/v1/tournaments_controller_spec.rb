require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::TournamentsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:woman) { FactoryGirl.create(:woman) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:club) { FactoryGirl.create(:club) }
  render_views


  before(:each) do
    allow(controller).to receive(:sign_in)
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:partner).and_return(woman)

    authWithUser(user)

    values = { placing: 1, points: 12, address: 'test', date: Time.now, kind: 'Lat', place: 3, participants: 23, status: 'OK' }
    @tournament = double('Tournament', values.merge({ number: 23 }))
    @tournaments = [@tournament, double('Tournament', values.merge({ number: 42 }))]
  end

  describe "#index" do
    it "should give back all user tournaments" do
      user.should_receive(:tournaments).and_return(@tournaments)

      get :index, :format => :json

      should respond_with 200
      expect(json[0]['number']).to eq(23)
      expect(json[1]['number']).to eq(42)
    end

    it "every tournament should containt number, status, points and placings" do
      user.stub(:tournaments).and_return(@tournaments)
      get :index, :format => :json

      expect(json[0]['number']).to eq(@tournament.number)
      expect(json[0]['placing']).to eq(@tournament.placing)
      expect(json[0]['points']).to eq(@tournament.points)
      expect(json[0]['status']).to eq(@tournament.status)
      expect(json[0]['participants']).to eq(@tournament.participants)
      expect(json[0]['place']).to eq(@tournament.place)
    end

    it "every tournament should containt address and time" do
      user.stub(:tournaments).and_return(@tournaments)
      get :index, :format => :json

      expect(json[0]['address']).to eq(@tournament.address)
      expect(json[0]['kind']).to eq(@tournament.kind)
    end
  end

  describe "#create" do
    it "should create a future tournament with right params" do
      expect{ post :create, { number: 123456 }}.to change{ Tournament.count }.by(1)

      should respond_with :created
    end

    it "should create a done tournament with right params" do
      expect{ post :create, { number: 123456, place: 3, participants: 20 }}.to change{ Tournament.count }.by(1)

      should respond_with :created
    end

    it "should not create a tournament if one exists with this number" do
      Tournament.stub(:where).and_return([tournament])
      expect{ post :create, { number: 123456, place: 3, participants: 20 }}.to change{ Tournament.count }.by(0)

      should respond_with :not_acceptable
    end
  end

  describe "#update" do
    it "should update the right tournament" do
      tournament.number = 123456
      tournament.save!

      user.stub(:tournaments).and_return([tournament])
      expect{ put :update, { number: 123456, place: 3, participants: 12 } }.to change{ tournament.place }.to(3)

      should respond_with :ok
    end

    it "should error if no tournament found" do
      tournament.number = 123456
      tournament.save!

      user.stub(:tournaments).and_return([tournament])
      expect{ put :update, { number: 123456789, place: 3, participants: 12 } }.not_to change{ tournament.place }.to(3)

      should respond_with :not_found
    end
  end

  describe "#destroy" do
    it "should destroy the right tournament" do
      tournament.number = 123456
      tournament.save!

      user.stub(:tournaments).and_return([tournament])
      tournament.should_receive(:destroy)
      delete :destroy, { number: 123456 }

      should respond_with :ok

    end

    it "should error if no tournament found" do
      tournament.number = 123456
      tournament.save!

      user.stub(:tournaments).and_return([tournament])
      tournament.should_not_receive(:destroy)
      delete :destroy, { number: 123456789 }

      should respond_with :not_found
    end

    describe "admin only" do
      describe "#change status" do
        it "should give a not authorized if the current_user is not an admin of this tournament" do
          Club.stub(:ownedBy).and_return([club])
          tournament.stub(:belongsToClub).with([club.id]).and_return(false)

          put :changeStatus, {id: tournament.id, status: 'enrolled', format: :json }

          should respond_with :unauthorized
        end

        it "should give a not found if tournament was not found" do
          Club.stub(:ownedBy).and_return([club])
          tournament.stub(:belongsToClub).with([club.id]).and_return(true)
          Tournament.stub(:where).with(id: tournament.id).and_return([])

          put :changeStatus, {id: tournament.id, status: 'enrolled', format: :json }

          should respond_with :not_found
        end

        it "should give an invalid request if status is not one of enrolled, unenrolled or cancelled" do
          Club.stub(:ownedBy).and_return([club])
          tournament.stub(:belongsToClub).with([club.id]).and_return(true)

          put :changeStatus, {id: tournament.id, status: 'unknown status', format: :json }

          should respond_with :bad_request
        end

        it "should change the tournaments status" do
          Club.stub(:ownedBy).and_return([club])
          tournament.stub(:belongsToClub).with([club.id]).and_return(true)

         # TODO: Check what tournament.status was before and manipulate it maybe

          expect { put :changeStatus, {id: tournament.id, status: 'enrolled', format: :json } }.to change{ tournament.status }.to(:enrolled)

          should respond_with :ok
        end
      end
    end
  end
end