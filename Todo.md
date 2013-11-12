Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Refactorings
---------------------
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses

#77 + #64
-------------------

  - Refactor couples controller
    - Dry up
    - move into model
  - introduce [CanCan](https://github.com/ryanb/cancan) or another ability concept
	- reinitialize the svgs on dashboard on orientation change (http://davidwalsh.name/orientation-change)