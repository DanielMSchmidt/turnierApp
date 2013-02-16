desc "This task is called to send an test email to test sidekiq"
task :test_sidekiq => :environment do
  MailerTestWorker.perform_async
end