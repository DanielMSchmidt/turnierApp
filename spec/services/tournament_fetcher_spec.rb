# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TournamentFetcher do
  describe "fetching" do
    it "should fetch tournaments correctly" do
      t = TournamentFetcher.new(40472).run
      expect(t[:date].to_s).to eq(DateTime.parse('20.04.2014 09:00').to_s)
      expect(t[:kind]).to eq('HGR C LAT')
    end
  end
end
