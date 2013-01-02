class NotificationMailer < ActionMailer::Base
  default from: "turnierlist@psv-kiel.de"

  def enrollCouples(user, club)
    @club = club
    mail to: user.email, subject: "Im #{@club.name} gibt es Paare zu melden"
  end

  def userCount(count)
    @count = count
    mail to: "daniel.maximilian@gmx.net", subject: "Die Anzahl der Paare in der Turnierapp liegt bei #{@count}"
  end
end
