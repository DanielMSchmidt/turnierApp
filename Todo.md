Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Refactorings
---------------------
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses

FIXME
======

- Post tournaments doesn't work anymore / right time to put fetching into a worker job

- check if deployment will work
- check if foreman export has to be renewed
- check why address fetching doesn't work anymore