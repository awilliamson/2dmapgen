# Write your [mocha](http://visionmedia.github.com/mocha/) specs here.

should = require "should"
app = require "../code/app/app.coffee"

describe 'Map', ->
	map = new Map(10,10)
	map.should.exist
	describe 'data', ->
		map.data.length.should.equal(9)
		map.data[0].length.should.equal(9)
