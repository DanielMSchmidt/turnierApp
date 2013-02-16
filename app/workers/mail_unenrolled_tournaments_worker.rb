class MailUnenrolledTournamentsWorker
  include Sidekiq::Worker

  def perform(club)
    if (club.unenrolled_and_enrollable_tournaments_left_which_should_be_notified)
      NotificationMailer.enrollCouples(club.owner, club).deliver
      club.tournaments.each{|x| x.notification_send}
      logger.debug "send weekly mail to #{club.name} at mail #{club.owner.email}"
    else
      logger.debug "did not send weekly mail to #{club.name}"
    end
  end
end