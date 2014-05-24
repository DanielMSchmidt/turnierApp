class TournamentEnhancementWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(tournament_id, tournament_number, user_id)
    logger.debug { "Worker starts for (#{tournament_id} / #{tournament_number} / #{user_id})" }
    tournament_infos = TournamentFetcher.new(tournament_number).run
    tournament = Tournament.find(tournament_id)

    tournament[:kind]    = tournament_infos.kind
    tournament[:address] = "#{tournament_infos.street} \n #{tournament_infos.zip} #{tournament_infos.city}"
    tournament[:notes]   = tournament_infos.notes
    tournament[:date]    = tournament_infos.datetime

    tournament.assignToUser(user_id)
    tournament.fillupMissingData
    tournament.fetched = true

    tournament.save!
    logger.debug "Worker ends"
  end
end
