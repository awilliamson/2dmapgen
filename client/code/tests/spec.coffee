# Write your [mocha](http://visionmedia.github.com/mocha/) specs here.

expect = chai.expect

describe 'Map', ->
	it 'Should exist', ->
		@world = new World(32,10,10)
		@map = @world.map
		expect(@map).to.exist

	it 'Should be an instance of window.Map', ->
		expect(@map).to.be.an.instanceOf(window.Map)

	it 'Should be an object', ->
		expect(@map).to.be.a('object')

describe 'Map Data', ->

	it 'Should be a 2D Array of correct length, for x, and y', ->
		if expect(@map.data.length).to.equal(10)
			expect(@map.data[i].length).to.equal(10) for i in [0...@map.data.length]

	it 'Should have Start and End Locations set correctly', ->
		expect(@map.data[0][9]).to.equal(2)
		expect(@map.data[9][0]).to.equal(3)

describe 'Terrain Types', ->

	it 'Should exist as a property of map, and have more than 2 entries', ->
		expect(@map).to.have.property('types')
		expect(@map.types.length).to.be.above(2)

	it 'Should have strings at each index', ->
		expect(@map.types[i]).to.be.a('string') for i in [0...@map.types.length]

	it 'Should be of type, array', ->
		expect(@map).to.have.property('types').to.be.a('array')

	it 'Should be in correct order', ->
		order = ['space','wall','start','end']
		expect(@map.types[i]).to.equal(order[i]) for i in [0...order.length]

describe 'Valid Reference Function', ->

	array = [ [1,1], [0,0], [10,10], [5,5] ]
	valids = [1,0,1,1]

	it 'Should return correct response for inputted co-ordinates, in human form', ->
		expect(@map.validReference(array[i][0],array[i][1])).to.equal(valids[i]) for i in [0...array.length]

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
		expect(array[i]).to.be.a('array') for i in [0...array.length]

describe 'World', ->

	args = ['res','width','height']
	argVals = [32,10,10]

	it 'Should exist', ->
		expect(@world).to.be.a('object')

	it 'Should have correct arguments', ->
		expect(@world).to.have.property(args[i]) for i in [0...args.length]

	it 'Should have correct values for arguments passed to it', ->
		expect(@world).to.have.property(args[i]).to.be.equal(argVals[i]) for i in [0...args.length]



