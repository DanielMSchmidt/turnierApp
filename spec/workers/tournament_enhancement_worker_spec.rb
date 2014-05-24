# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TournamentEnhancementWorker do
  describe "#perform" do
    before(:each) do
      @tournamnent_result = double('tournament_result', kind: true, street: true, zip: true, city: true, notes: true, datetime: true)
      @fetcher = double('fetcher', run: @tournamnent_result, assignToUser: 3)
      TournamentFetcher.stub(:new).and_return(@fetcher)
      @tournament_record = double('tournament_record', :[]= => true, :assignToUser => true, :fillupMissingData => true, :fetched= => true, :save! => true)
      Tournament.stub(:find).and_return(@tournament_record)
    end

    it "should run the tournament fetcher" do
      @fetcher.should_receive(:run)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be assigned to the user" do
      @tournament_record.should_receive(:assignToUser).with(1)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be fetched" do
      @tournament_record.should_receive(:fetched=).with(true)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end

    it "should be saved" do
      @tournament_record.should_receive(:save!)
      TournamentEnhancementWorker.new.perform(42, 23, 1)
    end
  end
end
