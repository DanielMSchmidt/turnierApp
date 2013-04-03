require 'spec_helper'
require 'capybara/rails'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  describe "structure" do
    it { should have_many(:couples) }
    it "shouldnt have more then one active couple per time" do

      user.couples.count.should eq(0)
      user.couples.create(FactoryGirl.attributes_for(:couple))

      couple_id = user.activeCouple.id

      user.couples.create(FactoryGirl.attributes_for(:couple))
      user.couples.count.should eq(2)

      user.activeCouples.id.should_not eq(couple_id)
    end
  end
end