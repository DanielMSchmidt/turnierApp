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
      - change memberships from user to couples
      - js für die tab aktivierung schreiben oder schauen wieso die nicht active sind
      - Test it out and hopefully write tests for it
    - Make all forms horizontal forms (with bootstrap)

  - v0.85
    - Make a basic layout for all dashboards which is responsive

  - v0.9
    - Facebook login
    - add images (to events & couples)

Refactorings
---------------------
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses