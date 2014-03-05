class AdminMailerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly }

  def perform
    Club.all.each do |club|
      AdminMailer.weekly(club).deliver
    end
  end
end