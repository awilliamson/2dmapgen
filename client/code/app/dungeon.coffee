#! Dungeon.coffee

class Dungeon
	constructor: (@w,@h) ->
		@data = @constructMap(@w,@h)

		if @data
			rooms = 0
			attempts = 0
			@makeRooms(rooms,attempts)

	#types: ['space','wall','start','end']

	constructMap: (w,h) ->
		(1 for x in [0...w] for y in [0...h])


	dig: (type,startPos) ->
		if type? is "room" or 0
			console.log("Room")
		if type? is "corridor" or 1
			console.log("Corridor")
		else
			return -1


	makeRooms: (rooms,attempts)->
		if attempts <= 250

			len = @w - 1
			height = @h - 1

			max = [len/20,height/20].map (item) => Math.floor(item)
			min = [2,2]

			randomSize = []
			randomSize.push(@randInt(min[i],max[i])) for i in [0...max.length]

			if rooms <= 0


				roomStart = [Math.ceil(len/2), Math.ceil(height/2)] # This will be the top left of le room

				for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
					for y in [roomStart[1]..(roomStart[1]+randomSize[1])]
						@data[x][y] = 0

				console.log("RoomStart at #{roomStart}")
				console.log("randomSize at #{randomSize}")
				@cells = @getAdj(roomStart,randomSize)

				for item in @cells #Highlight Adj cells for debug.
					@data[item[0]][item[1]] = 2

				rooms += 1
				@makeRooms(rooms,attempts)

			else if rooms > 0 and rooms < 30

				console.log("Entered rooms > 0 loop")
				console.log("Cell Length #{@cells.length}")

				if @cells?
					roomStart = @cells[@randInt(0,@cells.length-1)]
				console.log("roomStart is #{roomStart}")

				console.log("Room Intersection is #{@roomIntersection(roomStart,randomSize)}")

				if @roomIntersection(roomStart,randomSize) is false

					for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
						for y in [roomStart[1]..(roomStart[1]+randomSize[1])]
							@data[x][y] = 0


					@cells = @getAdj(roomStart,randomSize)
					rooms += 1
					console.log("Rooms is now at #{rooms}")
				else if @roomIntersection(roomStart,randomSize) is true

					attempts += 1

				for item in @cells # Highlight Adj cells for debug
						@data[item[0]][item[1]] = 2

				@makeRooms(rooms,attempts)
		else if attempts > 250
			console.log("Maximum number of attempts reached")


	roomIntersection: (roomStart,randomSize) ->

		for x in [roomStart[0]-1..(roomStart[0]+randomSize[0]+1)] #-1 and +1 ensure wall spaces between every room that's checked.
			for y in [roomStart[1]-1..(roomStart[1]+randomSize[1]+1)]
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


		#Inefficient i know, but i couldn't be arsed comparing Square - Corners vs Sum of 2 rects. This is easier to read.
		for x in [roomStart[0]-1..(roomStart[0]+randomSize[0]+1)]
			for y in [roomStart[1]..(roomStart[0]+randomSize[1])]
				if @data[x][y] >= 1 and @validReference(x,y)
					cells.push([x,y])

		for x in [roomStart[0]..(roomStart[0]+randomSize[0])]
			for y in [roomStart[1]-1..(roomStart[0]+randomSize[1]+1)]
				if @data[x][y] >= 1 and @validReference(x,y)
					cells.push([x,y])

		console.log("Cells is #{cells}")
		if cells?
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
	