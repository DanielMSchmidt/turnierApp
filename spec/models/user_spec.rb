# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it "should hava a working factory" do
    user.should be_valid
  end

  describe "hooks" do
    before(:each) do
      #clear all users
      User.all.each{|u| u.delete}
    end

    it "should call a build the couple function" do
      a = User.new(email: "tester1@test.de", name: "tester1", password: "123456789012")
      a.should_receive(:buildEmptyCouple)
      a.should_receive(:notifyAboutNewUser).and_return(true)
      a.save!
    end

    it "should create a couple after creation" do
      expect{User.create(email: "tester12@test.de", name: "tester", password: "123456789")}.to change{Couple.count}.by(1)
    end

    it "should have an acticeCouple after creation" do
      a = User.create(email: "tester123@test.de", name: "tester12", password: "123456789012")

      a.activeCouple.should_not be_nil
    end

    it "should create progresses for the active couple" do
      a = User.create(email: "tester12345@test.de", name: "tester124", password: "123456789012345")

      a.activeCouple.latin.should_not be_nil
      a.activeCouple.standard.should_not be_nil
    end
  end

  describe "structure" do
    it "shouldnt have more then one active couple per time" do
      user.getCouples.each{|couple| couple.delete}
      user.getCouples.count.should eq(0)

      first_couple = Couple.create({man_id: user.id, woman_id: 42, active: true})

      # doesnt work here, works in console
      #first_couple.should_receive(:deactivate)

      second_couple = Couple.new({man_id: user.id, woman_id: 43, active: true})
      second_couple.should_receive(:deactivateOtherCouples)
      Couple.where(man_id: user.id).count.should eq(1)

      second_couple.save
      Couple.where(man_id: user.id).count.should eq(2)
      user.getCouples.count.should eq(2)
    end
  end

  describe "functions" do
    describe "#activeCouple" do
      it "should return a couple if an active couple is assigned" do
        couple = double('couple', active: true)
        user.stub(:getCouples).and_return([couple])
        user.activeCouple.should eq(couple)
      end
    end

    describe "#getIdByName" do
      it "should return nil if no user was found" do
        User.stub(:where).and_return([])
        User.getIdByName('test').should be_nil
      end

      it "should return the id if a user was found" do
        User.stub(:where).and_return([double('user', id:1)])
        User.getIdByName('test').should_not be_nil
        User.getIdByName('test').should eq(1)
      end
    end

    describe "#isntSet" do
      it "should return true if the param is nil" do
        User.isntSet(nil).should be_true
      end

      it "should return true if the param is 'Noch nicht eingetragen'" do
        User.isntSet('Noch nicht eingetragen').should be_true
      end

      it "should return true if the param is ''" do
        User.isntSet('').should be_true
      end

      it "should return false if it's something else" do
        User.isntSet('Test').should be_false
      end
    end

    describe "#to_i" do
      it "should return the id" do
        user.to_i.should eq(user.id)
      end
    end

    describe "#to_s" do
      it "should return the right string" do
        user.to_s.should eq("User: #{user.id} - #{user.email}")
      end
    end

    describe "#sendUserNotification" do
      it "should send a mail with the right params" do
        newUser = double('new user')
        NotificationMailer.should_receive(:userCount).with(User.all, newUser).and_return(double('mail', deliver: true))
        User.sendUserNotification(newUser)
      end
    end
  end
end
