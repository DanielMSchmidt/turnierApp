require 'spec_helper'
require 'capybara/rails'

describe "Tournament" do
  before(:each) do
    @user ||= FactoryGirl.create(:user)
    @club ||= FactoryGirl.create(:club)
    FactoryGirl.create(:membership)
    ActionMailer::Base.deliveries = []
  end

  describe "as deleted" do
    it "should send if future, enrolled tournament is deleted" do
      ActionMailer::Base.deliveries.count.should == 0

      tournament = @user.tournaments.create!(number: 30129)
      tournament.enrolled = true
      tournament.save
      assert(tournament.enrolled?, "tournament should be enrolled")
      tournament.delete

      ActionMailer::Base.deliveries.count.should == 1
      ActionMailer::Base.deliveries.last.to.should == [@club.owner.email]
      ActionMailer::Base.deliveries.last.subject.should == "Ein Paar will doch nicht zu einem bereits gemeldeten Turnier"
    end

    it "shouldn't send if future, unenrolled tournament is delted" do
      ActionMailer::Base.deliveries.count.should == 0

      tournament = @user.tournaments.create!(number: 30129)
      tournament.enrolled = false
      tournament.save
      assert(!tournament.enrolled?, "tournament shouldn't be enrolled")
      tournament.delete

      ActionMailer::Base.deliveries.count.should == 0
    end

    it "shouldn't send if danced, enrolled tournament is delted" do
      ActionMailer::Base.deliveries.count.should == 0

      tournament = @user.tournaments.create!(number: 30129, place: 1, participants: 3)
      tournament.enrolled = true
      tournament.save
      assert(tournament.enrolled?, "tournament should be enrolled")
      tournament.delete

      ActionMailer::Base.deliveries.count.should == 0
    end
  end
end