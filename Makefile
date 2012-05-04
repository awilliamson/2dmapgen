#/ Makefile

test:
	node_modules/.bin/mocha --compilers coffee:coffee-script ./client/tests/spec.coffee