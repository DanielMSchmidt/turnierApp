class EnhancementWorker
  include Sidekiq::Worker

  def perform(tournament_id, tournament_number)
    tournament_infos = TournamentFetcher.new(tournament_number).run
    begin
      tournament = Tournament.find(tournament_id)
    rescue Exception
      logger.debug "This tournament doesn't exists"
      return false
    end

    [:kind, :address, :date, :kind, :notes].each do |key|
      tournament[key] = tournament_infos[key]
    end
    tournament.save
  end
end