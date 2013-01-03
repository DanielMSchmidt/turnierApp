class NotificationMailer < ActionMailer::Base
  default from: "turnierlist@psv-kiel.de"

  def enrollCouples(user, club)
    @club = club
    mail to: user.email, subject: "Im #{@club.name} gibt es Paare zu melden"
  end

  def userCount(user, newUser)
    @count = user.count
    @user = user
    @newUser = newUser
    mail to: "daniel.maximilian@gmx.net", subject: "Neuer Nutzer mit Namen #{newUser} | Total: #{@count}"
  end
end
