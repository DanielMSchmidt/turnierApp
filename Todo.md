=On deploy:
  heroku config:add NEWRELIC_DISPATCHER=Puma

=Other todos
  - Test Puma
  - Add Staging System
  - Distinguish between Std and Lat at Stats
  - Add extra buttons for add previous tournament and upcoming tournament
  - Fix bug with Mechanize that wen 2 turnaments start at the same time and the second one is the one you want to dance
  - Mail asynch with sidekiq