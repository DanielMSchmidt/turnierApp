require 'spec_helper'
require 'capybara/rails'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it "should hava a working factory" do
    user.should be_valid
  end

  describe "structure" do
    it { should respond_to(:couples) }
    it "shouldnt have more then one active couple per time" do
      user.get_couples.count.should eq(0)
      first_couple = Couple.create({man_id: user.id, woman_id: 42, active: true})
      second_couple = Couple.create({man_id: user.id, woman_id: 43, active: true})
      user.get_couples.count.should eq(2)

      pending #doesn't work jet

      second_couple.active.should be_true
      first_couple.active.should be_false
    end
  end
end