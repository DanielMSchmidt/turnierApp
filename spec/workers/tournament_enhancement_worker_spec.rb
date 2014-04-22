# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TournamentEnhancementWorker do
  describe "#perform" do
    before(:each) do
      @fetcher = double('fetcher', run: {:kind => true, :address => true, :date => true, :notes => true}, assignToUser: 3)
      TournamentFetcher.stub(:new).and_return(@fetcher)
      @tournament = double('tournament', :[]= => true, :assignToUser => true, :fillupMissingData => true, :fetched= => true, :save! => true)
      Tournament.stub(:find).and_return(@tournament)
    end

    it "should run the tournament fetcher" do
      @fetcher.should_receive(:run)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be assigned to the user" do
      @tournament.should_receive(:assignToUser).with(1)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be fetched" do
      @tournament.should_receive(:fetched=).with(true)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be saved" do
      @tournament.should_receive(:save!)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end
  end
end
