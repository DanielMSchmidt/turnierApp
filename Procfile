web: bundle exec rails server puma -p 9000 -e $RACK_ENV
redis: redis-server --port 6379
worker: bundle exec sidekiq -L log/sidekiq.log