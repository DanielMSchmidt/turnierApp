=On deploy:
  heroku config:add NEWRELIC_DISPATCHER=Puma

=Other todos
  - Fix bug with Mechanize that wen 2 turnaments start at the same time and the second one is the one you want to dance
  - Distinguish between Std and Lat at Stats
  - Add extra buttons for add previous tournament and upcoming tournament
  - Mail asynch with sidekiq (http://manuel.manuelles.nl/blog/2012/11/13/scalable-heroku-worker-for-sidekiq/)
  - handle n+1 queries better
  - Add some Facebook stuff like hidden group for people who don't want to login and autopost before/after tournament or s.th. like that