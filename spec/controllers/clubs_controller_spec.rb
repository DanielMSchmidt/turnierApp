require 'spec_helper'

describe ClubsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:club) { FactoryGirl.create(:club) }
  let!(:other_club) { FactoryGirl.create(:club) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:woman) { FactoryGirl.create(:woman) }

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

      @tournament1 = double('Tournament1', number: 42, users: [], destroy: true)
      @tournament2 = double('Tournament2', number: 23, users: [woman], destroy: true)

      Club.stub(:find).and_return(club)
    end

    describe "should fail if" do
      it "the current_user is not the owner" do
        club.should_receive(:is_owner).with(user).and_return(false)
        club.stub(:tournaments).and_return([@tournament1, @tournament2])
        expect {
          get :cancel, {club_id: 23, number: 42}
        }.not_to change {Tournament.count}
      end

      it "there are no tournaments" do
        club.should_receive(:is_owner).with(user).and_return(true)
        club.should_receive(:tournaments).and_return(nil)

        expect {
          get :cancel, {club_id: 23, number: 42}
        }.not_to change {Tournament.count}
      end
    end

    describe "should succeed and " do
      before(:each) do
        club.stub(:is_owner).and_return(true)
        club.stub(:tournaments).and_return([@tournament1, @tournament2])
      end

      it "should mail every user which this tournament" do
        mail = double('Mail')
        NotificationMailer.should_receive(:cancelTournament).with(woman, 23).and_return(mail)
        mail.should_receive(:deliver)

        get :cancel, {club_id: 5, number: 23}
      end

      it "should destroy each of those tournaments" do
        @tournament1.should_receive(:destroy)
        @tournament2.should_not_receive(:destroy)
        get :cancel, {club_id: 5, number: 42}
      end
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
