# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'capybara/rails'

describe Couple do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:woman) { FactoryGirl.create(:woman) }
  let!(:couple) {
    c = Couple.create(man_id: user.id, woman_id: woman.id, active: true)
    c.save!
    c
  }



  describe "structure" do
    it "should have a man assigned" do
      couple.should respond_to(:man)
    end

    it "should have a woman assigned" do
      couple.should respond_to(:woman)
    end

    it "should have many progresses" do
      couple.should respond_to(:progresses)
    end

    it { should respond_to(:active) }
  end

  describe "functions" do
    it { should respond_to(:latin, :standard) }

    describe "#createFromParams" do
      before(:each) do
        @defaultParam = {couple: {man: 42, woman: 23, latin_kind: 'C', standard_kind: 'B'}}
      end

      it "should build progresses" do
        Couple.stub(:new).and_return(couple)
        User.stub(:getIdByName).and_return(42)

        couple.stub(:consistsOfCurrentUser).and_return(true)

        expect {
          Couple.createFromParams(@defaultParam, user)
        }.to change{Progress.count}.by(2)
      end

      it "should save the couple" do
        Couple.stub(:new).and_return(couple)
        User.stub(:getIdByName).and_return(42)

        couple.stub(:consistsOfCurrentUser).and_return(true)
        couple.should_receive(:save).and_return(true)

        Couple.createFromParams(@defaultParam, user)
      end

      it "should not allow nil in man or woman id" do
        Couple.stub(:new).and_return(couple)
        User.stub(:getIdByName).and_return(nil)

        couple.stub(:consistsOfCurrentUser).and_return(true)
        couple.should_not_receive(:save)
        @defaultParam[:couple][:man_id] = nil

        expect {
            Couple.createFromParams(@defaultParam, user)
        }.to raise_error(PartnersNotSet)
      end

      it "should allow nil in man or woman id if allow nil is true" do
        Couple.stub(:new).and_return(couple)
        User.stub(:getIdByName).and_return(nil)

        couple.stub(:consistsOfCurrentUser).and_return(true)
        couple.should_receive(:save).and_return(true)
        @defaultParam[:couple][:man_id] = nil

        Couple.createFromParams(@defaultParam, user, true)
      end

      it "should not save anything if its the wrong user" do
        Couple.stub(:new).and_return(couple)
        User.stub(:getIdByName).and_return(42)

        couple.stub(:consistsOfCurrentUser).and_return(false)
        couple.should_not_receive(:save)
        expect{
            Couple.createFromParams(@defaultParam, user)
        }.to raise_error(DoesntConsistOfUser)

      end
    end
  end
end
