#! Dungeon.coffee

class Dungeon
	constructor: (@w,@h) ->
		@data = @constructMap(@w,@h)

		if @data
			rooms = 0
			@makeRooms(rooms)

	types: ['space','wall','start','end']

	constructMap: (w,h) ->
		(1 for x in [0...w] for y in [0...h])



	makeRooms: (rooms)->

		len = @w - 1
		height = @h - 1

		max = [len/20,height/20].map (item) => Math.floor(item)
		min = [2,2]

		console.log("Max is currently #{max}")
		console.log("Min is currently #{min}")
		randomSize = []
		randomSize.push(@randInt(min[i],max[i])) for i in [0...max.length]
		#randomSize.push(@randInt(min[i],max[i])) for i in max
		console.log("RandomSize #{randomSize}")

		if rooms <= 0

			console.log("Entered rooms <= 0 loop")

			roomStart = [Math.ceil(len/2), Math.ceil(height/2)]

			console.log("RoomStart #{roomStart}")

			for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
				for y in [roomStart[1]..(roomStart[1]+randomSize[1])]
					@data[x][y] = 0

			@cells = @getAdj(roomStart,randomSize)
			rooms += 1
			console.log("Rooms is now at #{rooms}")
			@makeRooms(rooms)

		else if rooms > 0 and rooms < 10

			console.log("Entered rooms > 0 loop")
			console.log("Cell Length #{@cells.length}")

			roomStart = @cells[@randInt(0,@cells.length-1)]
			console.log("roomStart is #{roomStart}")

			if @roomIntersection(roomStart,randomSize) is false

				for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
					for y in [roomStart[1]..(roomStart[1]+randomSize[1])]
						@data[x][y] = 0


				@cells = @getAdj(roomStart,randomSize)
				rooms += 1
				console.log("Rooms is now at #{rooms}")

			@makeRooms(rooms)


	roomIntersection: (roomStart,randomSize) ->

		for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
			for y in [roomStart[1]..(roomStart[1]+randomSize[1])]
				if @validReference(x,y)
					if @data[x][y] is 0
						return true
					else
						return false
				else
					return true

	randInt: (min,max) ->
		Math.floor(Math.random()*(max-min+1))+min

	getAdj: (roomStart,randomSize)->

		cells = []

		for x in [roomStart[0]-1..(roomStart[0]+randomSize[0])]
			if @data[x][y] is 1
				cells.push([x,y])

		for y in [roomStart[1]..(roomStart[0]-1+randomSize[1])]
			if @data[x][y] is 1
				cells.push([x,y])

		console.log("Cells is #{cells}")
		return cells




	validReference: (x,y) ->
		return (x < @w & x >= 0) and (y < @h & x >= 0)

	getTypeByCoord: (x,y) ->
		if @validReference(x,y)
			return @data[x][y]

	getCoordByType: (type) ->

		array = []
		
		for y in [0...@h]
			for x in [0...@w]
				if @data[x][y] is type
					array.push([x,y])

		return array


module.exports = Dungeon
	