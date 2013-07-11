Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Other todos
---------------------
  - v0.8
    - New Admin dashboard
      - Panels for tabwise user stats
      - add generation of pdfs for upcoming and danced tournaments
        - by month
        - by year
      - js für die tab aktivierung schreiben oder schauen wieso die nicht active sind
      - Test it out and hopefully write tests for it
    - Make all forms horizontal forms (with bootstrap)

  - v0.82
    - Model side caching for data grabbing (http://railscasts.com/episodes/115-model-caching-revised)

  - v0.83
    - CSS3 Effekte einbauen

  - v0.85
    - Make a basic layout for all dashboards, which is responsive
    - Save address of user and add google maps directions
    - Integration level tests

  - v0.9
    - Facebook login
    - add images (to events & couples)

Refactorings
---------------------
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses