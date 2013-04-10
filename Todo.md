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
    - statistics for dashboard

  - v0.9
    - Facebook login
    - add images (to events & couples)

Refactorings
---------------------
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses