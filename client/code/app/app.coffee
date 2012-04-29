document.title = 'CoffeScript Wizardry'

class window.Map
    constructor: (@w,@h,@name) ->
        @data = (Math.round(Math.random()-0.3) for x in [1..@w] for y in [1..@h]) #Generate our 2D Array for our map
        #Comprised of 1's and 0's
    
        @data[0][@h-1] = 2; @data[@w-1][0] = 3 #Set Start in bottom left, End in top right. always.
        
        return @this
        
    types: ["Walkable Space","Wall","Start","End"] #Types array, so we can lookup terrain types based upon cell value
        
    validReference: (x,y) -> #Check is a cell is within the bounds of our map
        return (x <= @w & x > 0) && (y <= @h & x > 0) #If it's less than or equal to the limits of the system, 10,10
        #Above will return TRUE if both params are within the bounds, otherwise false.

    getCoordByType: (type) -> #Get the positions of all cells with Type 'type'
        console.time 'getCoordByType'

        array = []
        
        for y in [0...@h] 
            for x in [0...@w] 
                if @data[x][y] is type
                    array.push( [x,y] )
                    
        console.timeEnd 'getCoordByType'
        return array    
        
    getCellType: (x,y) -> #Check the cell type of a given cell
        if @validReference(x,y) #Validate the co-ords
            value = @map[x-1][y-1] #Look up that value, input is 1-n based, array is 0-n-1 based.    
            #return "Cell (#{x},#{y}) has a value of, #{value}, and is of Type, #{@types[value]}."
            return @types[value]

gameState =
    setup: ->
        console.time "setup"
        @map = new Map(10,10) #Generate a new map Object, 10 by 10 grid.
        #console.time 'setup' #Timer Start
        @blocks = new jaws.SpriteList()
        for coord in @map.getCoordByType(1)
            @blocks.push new jaws.Sprite
                image: "/img/wall.png"
                x: coord[0]*32
                y: coord[1]*32
        @tiles = new jaws.TileMap
            size: [@map.w,@map.h]
            cell_size: [32,32]
        @tiles.push(@blocks)
        console.timeEnd "setup" #Timer End
    update: ->

    draw: ->
        jaws.clear()
        @blocks.draw()


jaws.assets.add('/img/wall.png')
jaws.start(gameState)
#console.log("(#{coord[0]},#{coord[1]})") for coord in genMap.getIDByType("Wall")

#randx = Math.floor(Math.random()*newMap.w)+1
#randy = Math.floor(Math.random()*newMap.h)+1

#console.log randx
#console.log randy

#console.log newMap #Log this new object
#console.time 'getCellType'
#console.log "Co-ordinates (#{randx},#{randy}) have type #{newMap.getCellType(randx,randy)}" #Do some cellType Lookups
#console.timeEnd 'getCellType'
#console.log newMap.getCellType(1,10)
#console.log newMap.getCellType(10,1)
#console.log newMap.getIDByType("Wall") #Lookup the ID's of all cells with type Wall.

#console.time 'Display Walkable Array + Entries'