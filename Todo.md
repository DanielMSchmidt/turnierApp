Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Other todos
---------------------
  - v0.8
    - add generation of pdfs for upcoming and danced tournaments
    - make all forms horizontal forms (with bootstrap)
    - New Admin dashboard
      - Tabs for different Clubs if more then one (AJAX)
      - Panels for incoming requests, unenrolled tournaments, tabwise user stats
    - alert box for missing data in any tournament

  - v0.9
    - Facebook login
    - add images (to events & couples)

Refactorings
---------------------
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses