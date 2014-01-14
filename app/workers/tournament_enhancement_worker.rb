class TournamentEnhancementWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(tournament_id, tournament_number, user_id)
    logger.debug { "Worker starts for (#{tournament_id} / #{tournament_number} / #{user_id})" }
    tournament_infos = TournamentFetcher.new(tournament_number).run
    tournament = Tournament.find(tournament_id)

    if [:kind, :address, :date].map{|x| tournament_infos[x].blank? }.include?(true)
      logger.debug "Worker abords"
      raise "There was something blank fetched: #{tournament_infos}"
      return false
    end

    [:kind, :address, :date, :notes].each do |key|
      tournament[key] = tournament_infos[key]
    end

    tournament.assignToUser(user_id)
    tournament.fillupMissingData
    tournament.fetched = true

    tournament.save!
    logger.debug "Worker ends"
  end
end