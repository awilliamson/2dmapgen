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

	#it 'Should have Start and End Locations set correctly', ->
	#	expect(@map.data[0][9]).to.equal(2)
	#	expect(@map.data[9][0]).to.equal(3)

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

	array = [ [1,1], [0,0], [10,10], [5,5], [-1,-1] ]
	valids = [1,1,0,1,0]

	it 'Should return correct response for inputted co-ordinates', ->
		expect(@map.validReference(array[i][0],array[i][1])).to.equal(valids[i]) for i in [0...array.length]

#describe 'getCellType', ->

	#it 'Should return the value of the cell at the given co-ordinates', ->
	#    	
	#    start = @map.getCellType(0,9)
	#    end = @map.getCellType(9,0)

	#    expect(start).to.be.a('string')
	#    expect(start).to.equal('start')

	#    expect(end).to.be.a('string')
	#    expect(end).to.equal('end')

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

	it 'Should have a property, map, and be of type, object', ->
		expect(@world).to.have.property('map').to.be.a('object')

	it 'Should have a property, bounds, and be of type, object', ->
		expect(@world).to.have.property('bounds').to.be.a('object')

	it 'Should have a property, tiles, and be of type, object', ->
		expect(@world).to.have.property('tiles').to.be.a('object')

	it 'Should have a property, blocks, and be of type, object', ->
		expect(@world).to.have.property('blocks').to.be.a('object')

describe 'Initial Room', ->

	it 'Should have arrays, roomsArray, and, availCells', ->

		expect(@world.map).to.have.property('roomsArray').to.be.a('array')
		expect(@world.map).to.have.property('availCells').to.be.a('array')

	it 'Should make an initial room, and be an object', ->
		expect(@world.map).to.have.property('rooms').to.be.a('object')

	it 'Should be in the center', ->
		expect(@world.map.rooms.roomCenter[i]).to.equal(5) for i in [0..1]

	it 'Should have randInt outputting a value within bounds', ->
		for i in [0..10] 
			for j in [0..10]
				if i < j
					expect(@world.map.rooms.randInt(i,j)).to.be.within(i,j)

	it 'Should calculate upperLeft corner correctly', ->
		expect(@world.map.rooms.upperLeft[i]).to.equal(@world.map.rooms.roomCenter[i]-@world.map.rooms.randSize[i]) for i in [0..1]

	it 'Should have correct dimensions', ->
		expect(@world.map.data[x][y]).to.equal(0) for x in [@world.map.rooms.upperLeft[0]..(@world.map.rooms.upperLeft[0]+2*[@world.map.rooms.randSize[0]])] for y in [@world.map.rooms.upperLeft[1]..(@world.map.rooms.upperLeft[1]+2*[@world.map.rooms.randSize[1]])]

	it 'Should get perimeter of room correctly', ->
		@cells = []
		@data = (cell = 1 for x in [0...10] for y in [0...10])
		@data[x][y] = 0 for x in [3..4] for y in [3..4]
		console.log(@data)

		for x in [3..4]
			for y in [3..4]
				@world.map.rooms.getAdj(x,y,@cells)

		if expect(@cells).to.be.a('array')
			expect(@cells.length).to.equal(12)