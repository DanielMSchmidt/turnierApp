Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Refactorings
---------------------
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses


Mobile friendly
-----------------

  - Add browser gem (https://github.com/fnando/browser)
  - Stack all dashboard elems beneath each other
  - hide some tournament information or like this (http://css-tricks.com/responsive-data-tables/)
  - make modals (almost) fullpage I could use vh oder vw or just 100%, we'll see
  - distance between pages