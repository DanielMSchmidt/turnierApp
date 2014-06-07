require 'spec_helper'
include Devise::TestHelpers

describe MembershipController do
  let!(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user
  end

  describe "#create" do
    it "should redirect" do
      user.stub(:activeCouple).and_return(double('Couple', id: 42))

      post :create, {club_id: 3, user_id: user.id}

      assert_response :redirect
    end

    it "should create a membership" do
      user.stub(:activeCouple).and_return(double('Couple', id: 42))
      Membership.should_receive(:create!)

      post :create, {club_id: 3, user_id: user.id}
    end
  end

  describe "#verify" do
    it "should redirect" do
      post :verify, {club_id: 3, couple_id: 13}
      assert_response :redirect
    end

    it "should set membership to verified" do
      membership = double('Membership', save!: true)
      membership.should_receive(:verified=).with(true)
      Membership.should_receive(:where).with(couple_id: "13", club_id: "3").and_return([membership])

      post :verify, {club_id: 3, couple_id: 13}
    end
  end

  describe "#destroy" do
    it "should redirect" do
      post :destroy, {club_id: 3, couple_id: 13}

      assert_response :redirect
    end

    it "should destroy the membership" do
      Membership.should_receive(:destroy_all).with(couple_id: "13", club_id: "3")

      post :destroy, {club_id: 3, couple_id: 13}
    end
  end
end
