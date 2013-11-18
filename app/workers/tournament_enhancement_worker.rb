class TournamentEnhancementWorker
  include Sidekiq::Worker

  def perform(tournament_id, tournament_number, user_id)
    logger.debug { "Worker starts for (#{tournament_id} / #{tournament_number} / #{user_id})" }
    tournament_infos = TournamentFetcher.new(tournament_number).run
    tournament = Tournament.find(tournament_id)


    [:kind, :address, :date, :kind, :notes].each do |key|
      tournament[key] = tournament_infos[key]
    end

    tournament.assignToUser(user_id)
    tournament.fillupMissingData
    tournament.fetched = true

    tournament.save!
    logger.debug "Worker ends"
  end
end