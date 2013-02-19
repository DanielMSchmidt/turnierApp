=On deploy:
  heroku config:add NEWRELIC_DISPATCHER=Puma

=Other todos

  = v0.7
    - change usabiliy, so that a new user sees that he has to add a club
    - delte sidekiq workers again (doesn't work free with heroku)
    - put texts from controller to localization

  = v0.8

    - reorganise Users as Couples (of two new users)
    - Facebook login
    - add images (to events & couples)

=Refactorings
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form