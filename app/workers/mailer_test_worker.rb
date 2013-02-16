class MailerTestWorker
  include Sidekiq::Worker

  def perform
    NotificationMailer.userCount(User.all, User.first).deliver
  end
end