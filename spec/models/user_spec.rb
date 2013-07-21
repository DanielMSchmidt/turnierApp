# -*- encoding : utf-8 -*-
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
      user.get_couples.each{|couple| couple.delete}
      user.get_couples.count.should eq(0)

      first_couple = Couple.create({man_id: user.id, woman_id: 42, active: true})

      # doesnt work here, works in console
      #first_couple.should_receive(:deactivate)

      second_couple = Couple.new({man_id: user.id, woman_id: 43, active: true})
      second_couple.should_receive(:deactivate_other_couples)
      Couple.where(man_id: user.id).count.should eq(1)

      second_couple.save
      Couple.where(man_id: user.id).count.should eq(2)
      user.get_couples.count.should eq(2)
    end
  end

  describe "functions" do
    describe "#getOrganisedTournaments" do
      it "should return an empty array if the user hasnt got any clubs" do
        Club.stub(:where).and_return([])
        user.getOrganisedTournaments.should eq([])
      end
      it "should return all tournaments of the clubs associated with this user" do

        club1 = double('club1', name: 'club1' ,tournaments: [double('tournament1'), double('tournament2')])
        club2 = double('club2', name: 'club2' ,tournaments: [double('tournament3')])
        Club.stub(:where).and_return([club1, club2])

        user.getOrganisedTournaments.length.should eq(3)
      end
    end

    describe "#get_couples" do
      it "should return an emtpy array if there is no couple with the right id" do
        Couple.stub(:all).and_return([double('not_your_couple', man_id: 100, woman_id: 101)])

        user.get_couples.should be_empty
      end

      it "should return an array if there is a couple with the right man_id" do
        Couple.stub(:all).and_return([double('your_male_couple', man_id: user.id, woman_id: 101)])
        user.get_couples.should_not be_empty
      end

      it "should return an array if there is a couple with the right woman_id" do
        Couple.stub(:all).and_return([double('your_female_couple', man_id: 100, woman_id: user.id)])
        user.get_couples.should_not be_empty
      end
    end

    describe "#activeCouple" do
      it "should return nil if no couple is assigned" do
        user.stub(:get_couples).and_return([])
        user.activeCouple.should be_nil
      end

      it "should return nil if no active couple is assigned" do
        couple = double('couple', active: false)
        user.stub(:get_couples).and_return([couple])
        user.activeCouple.should be_nil
      end

      it "should return a couple if an active couple is assigned" do
        couple = double('couple', active: true)
        user.stub(:get_couples).and_return([couple])
        user.activeCouple.should eq(couple)
      end
    end

    describe "#get_id_by_name" do
      it "should return nil if no user was found" do
        User.stub(:where).and_return([])
        User.get_id_by_name('test').should be_nil
      end

      it "should return the id if a user was found" do
        User.stub(:where).and_return([double('user', id:1)])
        User.get_id_by_name('test').should_not be_nil
        User.get_id_by_name('test').should eq(1)
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

    describe "#send_user_notification" do
      it "should send a mail with the right params" do
        newUser = double('new user')
        NotificationMailer.should_receive(:userCount).with(User.all, newUser).and_return(double('mail', deliver: true))
        User.send_user_notification(newUser)
      end
    end
  end
end
