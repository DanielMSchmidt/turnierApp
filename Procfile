web: bundle exec rails server puma -p 9000 -e $RAILS_ENV
redis: redis-server --port 6379
worker: bundle exec sidekiq -L log/sidekiq.log