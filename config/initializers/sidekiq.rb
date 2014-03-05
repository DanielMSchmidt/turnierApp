Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://localhost:6379/3', :namespace => 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://localhost:6379/3', :namespace => 'sidekiq' }
end

AdminMailerWorker.perform_at(Date.commercial(Date.today.year, 1 + Date.today.cweek, 1).to_time)