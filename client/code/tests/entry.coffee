$ ->
	mocha.setup "bdd"
	require "/spec"
	mocha.run()