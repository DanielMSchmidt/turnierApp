class NotificationMailer < ActionMailer::Base
  default from: "turnierlist@psv-kiel.de"

  def enrollCouples(user, club)
    @club = club
    mail to: user.email, subject: "Im #{@club.name} gibt es Paare zu melden"
  end
end
