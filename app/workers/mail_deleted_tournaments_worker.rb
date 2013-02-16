class MailDeletedTournamentsWorker
  include Sidekiq::Worker

  def perform(tournament)
    logger.debug "MailDeletedTournamentsWorker started"

    if tournament.is_enrolled_and_not_danced?
      club_owners_mailaddresses = tournament.user.clubs.collect{|x| x.owner}.compact.collect{|x| x.email}
      logger.debug "enrolled tournamentDeleted Mail was send to #{club_owners_mailaddresses.join(', ')}"
      NotificationMailer.enrolledTournamentWasDeleted(club_owners_mailaddresses, tournament).deliver
    end
    logger.debug "deleted tournament #{tournament.to_s}"
    logger.debug "MailDeletedTournamentsWorker ended"
  end
end