# -*- encoding : utf-8 -*-
class NotificationMailer < ActionMailer::Base
  default from: "#{ENV['MAILER_ADDRESS']}"

  def enrollCouples(user, club)
    @club = club
    mail to: user.email, subject: "Im #{@club.name} gibt es Paare zu melden"
  end

  def userCount(user, newUser)
    @count = user.count
    @user = user
    @newUser = newUser
    mail to: "dschmidt@weluse.de", subject: "Neuer Nutzer mit Namen #{newUser} | Total: #{@count}"
  end

  def enrolledTournamentWasDeleted(club_owners_mailaddresses, tournament)
    @username = tournament.users.compact.collect{|x| x.name}.join(", ")
    @tournamentnumber = tournament.number

    mail to: club_owners_mailaddresses, subject: "#{@username} hat ein Turnier geloescht für das es schon gemeldet war"
  end

  def cancelTournament(user, number)
    @username = user.name
    @number = number

    mail to: user.email, subject: "Das Turnier mit der Nummer #{number} wurde abgesagt"
  end
end
