require 'spec_helper'

describe ClubsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:club) { FactoryGirl.create(:club) }
  let!(:other_club) { FactoryGirl.create(:club) }
  let!(:membership){ FactoryGirl.create(:membership) }
  let!(:tournament) { FactoryGirl.create(:tournament) }

  describe "#cancel_tournament" do
    before(:each) do
      #Stub the couple with it's tournaments
      @couple = double('couple', tournaments: [tournament])

      #We should be admin of this club
      club.stub(:is_owner).and_return(true)
      user.stub(:activeCouple).and_return(@couple)

      club.stub(:tournaments).and_return([tournament])
    end

    it "should send a mail to each user" do
      NotificationMailer.should_receive(:cancelTournament).with(user, 28288)
    end

    it "should delete each tournament with that nr" do
      tournament.should_receive(:delete)
    end

    it "shouldn't delete tournaments with another number" do
      tournament.number = 28289
      tournament.should_not_receive(:delete)
    end

    after(:each) do
      post :cancel, :club_id => 1
    end
  end
end
