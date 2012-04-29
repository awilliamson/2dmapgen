document.title = 'CoffeScript Wizardry'

class window.Map
    constructor: (@w,@h,@name) ->
        @map = (Math.round(Math.random()-0.3) for x in [1..@w] for y in [1..@h]) #Generate our 2D Array for our map
        #Comprised of 1's and 0's
    
        @map[0][@h-1] = 2; @map[@w-1][0] = 3 #Set Start in bottom left, End in top right. always.
        
        return @this
        
    types: ["Walkable Space","Wall","Start","End"] #Types array, so we can lookup terrain types based upon cell value
        
    validReference: (x,y) -> #Check is a cell is within the bounds of our map
        return (x <= @w & x > 0) && (y <= @h & x > 0) #If it's less than or equal to the limits of the system, 10,10
        #Above will return TRUE if both params are within the bounds, otherwise false.

    getIDByType: (type) -> #Get the positions of all cells with Type 'type'
        console.time 'getIDByType'
        console.log(    @getCellType(x,y) for y in [1..@h] for x in [1..@w]     ) #Print out our map in terms of type terrain
        
        array = []
        
        for y in [1..@h] 
            for x in [1..@w] 
                if (@getCellType(x,y).toLowerCase() == type.toLowerCase())
                    array.push( [x-1,y-1]   )
                    
        console.timeEnd 'getIDByType'
        return array    
        
    getCellType: (x,y) -> #Check the cell type of a given cell
        if @validReference(x,y) #Validate the co-ords
            value = @map[x-1][y-1] #Look up that value, input is 1-n based, array is 0-n-1 based.    
            #return "Cell (#{x},#{y}) has a value of, #{value}, and is of Type, #{@types[value]}."
            return @types[value]

gameState =
    setup: ->
        #console.time 'setup' #Timer Start
        blocks = new jaws.SpriteList()
        for coord in genMap.getIDByType("Wall")
            blocks.push new Sprite
                image: "/img/wall.png"
                x: coord[0]
                y: coord[1]
        tiles = new jaws.TileMap
            size: [genMap.w,genMap.h]
            cell_size: [32,32]
        tiles.push(blocks)
        #console.timeEnd 'setup' #Timer End
    update: ->

    draw: ->
        jaws.clear()
        blocks.draw()

genMap = new Map(10,10) #Generate a new map Object, 10 by 10 grid.
jaws.unpack
jaws.assets.add('img/wall.png')
#game_loop = new jaws.GameLoop(gameState, {fps: 60})
jaws.start(new jaws.GameLoop(gameState, {fps: 60}))
console.log("(#{coord[0]},#{coord[1]})") for coord in genMap.getIDByType("Wall")
while 1
    jaws.start(new jaws.GameLoop(gameState, {fps: 60}))

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