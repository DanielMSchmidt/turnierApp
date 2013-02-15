=On deploy:
  heroku config:add NEWRELIC_DISPATCHER=Puma

=Other todos
  = v0.6
    - Add extra buttons for add previous tournament and upcoming tournament
    - Mail asynch with sidekiq (http://manuel.manuelles.nl/blog/2012/11/13/scalable-heroku-worker-for-sidekiq/)
    - handle n+1 queries better
    - Add some Facebook stuff like hidden group for people who don't want to login and autopost before/after tournament or s.th. like that
  = v0.8
    - reorganise Users as Couples (of two new users)
    - Facebook login

=Refactorings
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)