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

    after(:each) do
      post :cancel, :club_id => 1
    end
  end
end
