# Write your [mocha](http://visionmedia.github.com/mocha/) specs here.

expect = chai.expect

describe 'Map Creation', ->
	it 'Map should exist', ->
		@map = new Map(10,10)
		expect(@map).to.exist

	it 'Map should be an instance of window.Map', ->
		expect(@map).to.be.an.instanceOf(window.Map)

	it 'Map should be an object', ->
		expect(@map).to.be.a('object')

describe 'Map Data', ->

	it '2D Array of correct length, for x, and y', ->
		expect(@map.data.length).to.equal(10)
		expect(@map.data[0].length).to.equal(10)

	it 'Start and End Locations set correctly', ->
		expect(@map.data[0][9]).to.equal(2)
		expect(@map.data[9][0]).to.equal(3)

describe 'Terrain Types', ->

	it 'Terrain array should exist as a property of map, and have more than 2 entries', ->
		expect(@map).to.have.property('types')
		expect(@map.types.length).to.be.above(2)

	it 'Terrain array should be of type, array', ->
		expect(@map).to.have.property('types').to.be.a('array')

	it 'Terrain strings should be in correct order', ->
		expect(@map.types[0]).to.equal('space')
		expect(@map.types[1]).to.equal('wall')
		expect(@map.types[2]).to.equal('start')
		expect(@map.types[3]).to.equal('end')

describe 'Valid Reference Function', ->

	it 'Given human like reference system, should return correct response for inputted co-ordinates', ->
		expect(@map.validReference(1,1)).to.equal(1)
		expect(@map.validReference(0,0)).to.equal(0)
		expect(@map.validReference(10,10)).to.equal(1)
		expect(@map.validReference(5,5)).to.equal(1)

describe 'getCellType', ->

	it 'Should return the value of the cell at the given co-ordinates', ->
	    	
	    start = @map.getCellType(1,10)
	    end = @map.getCellType(10,1)

	    expect(start).to.be.a('string')
	    expect(start).to.equal('start')

	    expect(end).to.be.a('string')
	    expect(end).to.equal('end')

describe 'getCoordByType', ->

	it 'Should return an array', ->
		expect(@map.getCoordByType(1)).to.be.a('array')

	it 'Should have an array at every index', ->
		array = @map.getCoordByType(1)
		expect(array[0]).to.be.a('array')

