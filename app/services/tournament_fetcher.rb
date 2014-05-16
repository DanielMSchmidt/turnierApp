# -*- encoding : utf-8 -*-
class TournamentFetcher
  def initialize(number)
    @number = number
    @tournament_data = DTVTournaments.get_cached_tournament(number)
  end

  def run
    @tournament_data
  end

  def rerun
    DTVTournaments.get(@number)
  end
end
