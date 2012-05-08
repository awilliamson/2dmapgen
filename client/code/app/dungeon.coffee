class Dungeon
	constructor: (@width, @height, @numRooms) ->
		@data = @boxer ' ', @width, @height
		@rooms = (@boxer('0', @randInt(4,10),@randInt(4,10)) for i in [0...@numRooms])
		@tetris()

	getCoordByVal: (val) -> 
		coords = []
		for x in [0...@width] 
			for y in [0...@height]
				if @data[x][y] is val
					coords.push([x,y])
		return coords

	boxer: (sym, h, w)->
		(sym for y in [0...h] for x in [0...w])

	paint: (p1,p2, char) ->
		for x in [p1[0]..p2[0]]
			for y in [p1[1]..p2[1]]
				@data[x][y] = char
				#@data[x][y] = input[Math.abs(x-p1[0])][Math.abs(y-p1[1])]
	free: (x,y) ->
		if @data[x] and @data[x][y] is ' ' then true else false

	walk: (x,y,dir,dis) ->
		if @free(x+2*dir[0],y+2*dir[1]) and dis > 0
			dis--
			@walk(x+dir[0],y+dir[1],dir,dis)
		else
			return [x,y]
	randInt: (min,max) ->
		Math.floor(Math.random()*(max-min+1))+min

	tetris: (rooms=@rooms) ->
		sides = -> 
			[[[null,0],[0,1]],[[@width-1,null],[-1,0]],[[null,@height-1],[0,-1]],[[0,null],[-1,0]]]
		total_fails = 0
		while rooms.length and total_fails <= 30
			room = rooms.pop()
			merged = false
			fails = 0
			num = 0
			until merged or fails > 10
				if num is 3 then num = 0
				#console.log num
				r1 = []; r2 = []; start = sides()[num]
				if start[0][0] is null then start[0][0] = @randInt(0,@height-1)
				if start[0][1] is null then start[0][1] = @randInt(0,@width-1)
				#console.log "start[0]", start[0], "start[1]", start[1]
				c1 = @walk(start[0][0],start[0][1],start[1],@width+@height)
				c2 = @walk(c1[0],c1[1],[start[1][1],start[1][0]],room[0].length)
				c3 = @walk(c2[0],c2[1],[-start[1][0],-start[1][1]],room.length)
				c4 = @walk(c3[0],c3[1],[-start[1][1],-start[1][0]],room[0].length)
				#console.log "c1",c1,"c2",c2,"c3",c3,"c4",c4
				#console.log "room x",room.length,"room y",room[0].length
				#console.log "c1-c3", c1[0]-c3[0], c1[1]-c3[1], "c2-c4", c2[0]-c4[0], c2[1]-c4[1]
				if Math.abs(c1[0]-c3[0]) is Math.abs(c2[0]-c4[0]) and Math.abs(c1[1]-c3[1]) is Math.abs(c2[1]-c4[1])
				#	console.log "Its a wrap, room is A-OK, adding to map"
					merged = true
				#	console.log "c3", c3
					@paint(c1,c3,'0')
				else
					fails++
				num++
				#@tetris(rooms)
			total_fails += fails
		console.log "done!"

module.exports = Dungeon