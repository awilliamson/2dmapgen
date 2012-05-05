# Write your [mocha](http://visionmedia.github.com/mocha/) specs here.

expect = chai.expect

describe 'Map', ->
	it "New Map Generation", ->
		map = new Map(10,10)
		expect(map).to.exist
		describe 'data', ->
			it "2D Array of correct length", ->
				expect(map.data.length).to.equal(10)
				expect(map.data[0].length).to.equal(10)