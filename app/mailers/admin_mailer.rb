# -*- encoding : utf-8 -*-
class AdminMailer < ActionMailer::Base
  default from: Figaro.env.mailer_address

  def weekly(club)
    @club = club
    @owner = club.owner
    @unenrolledTournaments = @club.unenrolledTournaments
    @results = @club.results(Time.now - 1.week, Time.now)

    mail to: @owner.email, subject: "Wöchentliche Aktualisierung für #{@club.to_s}"
  end
end
