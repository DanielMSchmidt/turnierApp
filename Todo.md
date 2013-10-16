Todos
====================

On deploy:
---------------------
  - heroku config:add NEWRELIC_DISPATCHER=Puma

Refactorings
---------------------
  - Data fetching should be refactored, really crappy! (and do it into service layer or lib)
  - merge tournaments _form and _future_form
  - refactor views/shared/progresses


Bugs
----

	- Fullpage nav doesn't work backwards (add hidden field, to detect if all pages are loaded)

Mobile friendly
-----------------

	- Add browser gem (https://github.com/fnando/browser)
	- Delete fullpage navigation on mobile
	- Stack all dashboard elems beneath each other
	- hide some tournament information or like this (http://css-tricks.com/responsive-data-tables/)
	- make modals (almost) fullpage I could use vh oder vw or just 100%, we'll see