require 'spec_helper'

describe ClubsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:club) { FactoryGirl.create(:club) }
  let!(:other_club) { FactoryGirl.create(:club) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:tournament) { FactoryGirl.create(:tournament) }

  describe "#create" do
    before(:each) do
      sign_in user
      Club.stub(:new).and_return(club)
    end

    it "should create a membership for the current couple" do
      expect {
        post :create, {club: {name: 'TEST'}}
      }.to change{Membership.count}.by(1)
    end

    it "should have the current_user assigned as user" do
      post :create, {club: {name: 'TEST'}}
      club.user.id.should eq(user.id)
    end
  end

  describe "#cancel" do
    before(:each) do
      sign_in user
      Club.stub(:find).and_return(club)
    end

    describe "should fail if" do
      it "the current_user is not the owner"
      it "there are no tournaments"
    end

    describe "should succeed and " do
      it "should mail every user which this tournament"
      it "should destroy each of those tournaments"
    end
  end

  describe "#transferOwnership" do
    before(:each) do
      sign_in user
      Club.stub(:find).and_return(club)

    end

    it "should transfer the user to the new one" do
      @second_user = double('Second User', id: 42)
      User.stub(:find).and_return(@second_user)
      club.should_receive(:transferTo)

      post :transferOwnership, {user_id: 42, club_id: 23}
    end
  end
end
