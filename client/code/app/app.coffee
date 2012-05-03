document.title = '2DMapGeneration by Ashley Williamson'

class window.Map
    constructor: (@w,@h,@name) ->
        # Generate our 2D Array, with weighted, rounded, random values.
        # This allows us to ensure that we will have majority walkable space within the map.
        # Random for now produces 1's or 0's to populate the array.
        # This will cycle thus: for x < @w, x++.
        # Put all this information into a 2D Array, this.data.

        @GRID_SPACING = 32

        @data = (Math.round(Math.random()-0.25) for x in [0...@w] for y in [0...@h])
        #@data = (cell = 1 for x in [0...@w] for y in [0...@h]) # Generate a fully walled map
    
        @data[0][@h-1] = 2; @data[@w-1][0] = 3 # Set Start in bottom left, End in top right.Start = 2, End = 3.

        @start = # Set objects for start and end locations, these will be used later for player positioning, and is also generally useful to reference.
            x: @GRID_SPACING/2+@GRID_SPACING
            y: (@h*@GRID_SPACING)-@GRID_SPACING/2 - @GRID_SPACING
        @end = 
            x: @w*@GRID_SPACING
            y: (@GRID_SPACING/2)-@GRID_SPACING/2
        
        console.log("Width and height are currently set to (#{@w},#{@h})")
        console.log("Starting position currently set to (#{@start.x},#{@start.y})")
        return this # Explicitally return this, otherwise it will default to return @end in this case.
        
    types: ["space","wall","start","end"] # Types array, allows us to lookup terrain types. Index matches with the terrain type, and can be used in conjunction with out nodes to display a map.
        
    validReference: (x,y) -> # Validate a cell, given by (x,y)
        return (x <= @w & x > 0) and (y <= @h & x > 0) # If both x and y are within the upper bounds, and are greater than 0, this will return True, only in that case.

    getCoordByType: (type) -> # Get an array containing cell positions of all cells that have a terrain type,'type', and return it.
        console.time 'getCoordByType' # Used to debug how long it will take to sort all of the cells within the map, this is given by xy.

        array = []
        
        for y in [0...@h] # y is iterated first to ensure proper formatting of our map for user display.
            for x in [0...@w]
                if @data[x][y] is type
                    array.push([x,y])
                    
        console.timeEnd 'getCoordByType'
        return array    
        
    getCellType: (x,y) -> # Check the terrain type of a given cell, given by (x,y)
        if @validReference(x,y) # Validate the the given co-ordinates before proceeding.
            value = @map[x-1][y-1] # Get the value of the cell at the given location. x-1, and y-1 are used because input is 1-n based, and the array is 0-(n-1) based.    
            return @types[value] # Use the previously defined types array, use the value from the cell to return the string which corresponds to it's type. Eg, value of 1, would result in "wall"

gameState = # Used to setup the game space for our level, several of these can be used for menu's etc.
    setup: -> # Called initially to setup all the level.
        console.time "setup" # Debug timer to see how long it takes to setup the level.
        @map = new Map(100,100) # Generate a new map Object, given x and y.
        @world = new jaws.Rect(0,0,@map.w*@map.GRID_SPACING,@map.h*@map.GRID_SPACING) # Create a jaws.Rect, this will represent the bounds of our 'world'
        #@spriteSheet = new jaws.Animation({sprite_sheet: "/img/16x16.png", frame_size: [16,16], orientation: "right", scale: 2})
        #console.time 'setup' #Timer Start
        @blocks = new jaws.SpriteList() # Make a new SpriteList, this will be used for playing our walls.
        for coord in @map.getCoordByType(1) # For each entry in the array responsible for walls.
            @blocks.push new jaws.Sprite # Make a new sprite, and push it.
                image: "/img/wall.png" # Setup parameters for the Sprite, args can be found in jaws documentation.
                x: coord[0]*@map.GRID_SPACING # Use the x,y co-ordinates from each entry, *32 as our sprites are 32x32 based, ensures correct spacing.
                y: coord[1]*@map.GRID_SPACING
        @tiles = new jaws.TileMap # Create a tilemap, this will be later used to render our walls. Ground is currently not a tilemap.
            size: [@map.w,@map.h] # Size set to the bounds of our map
            cell_size: [@map.GRID_SPACING,@map.GRID_SPACING] # Define how big each 'node' will be, in this instance it's 32x32, the size of our wall sprite.
        @tiles.push(@blocks) #Push our blocks, 'walls', to this tileMap so we can render later.

        @viewport = new jaws.Viewport({max_x: @world.width,max_y: @world.height}) # Make a new viewport


        # TODO - Fix the y co-ordinate position, it won't go past 284 ???
        @player = new jaws.Sprite # Create a player
            image: "/img/player.png" # Setup parameters for the player. Player.png is 30x30, to avoid collision issues, and such.
            x: @map.start.x
            y: @map.start.y # VERY STUPID Y CO-ORD
            anchor: "center"

        @player.move = (x,y)-> # Responsible for moving our player, given move (x,y).
            @x += x # This will move our player along by x, note: Can also be a negative number.
            if gameState.tiles.atRect(gameState.player.rect()).length > 0 # Check collisions with out tileMap (just walls for now)
                @x -= x #Negate the movement effects if we're gonna go into a wall.

            @y += y
            if gameState.tiles.atRect(gameState.player.rect()).length > 0
                @y -= y
        @player.move = _.throttle @player.move, 200 # Throttle move so we don't fly along at however fast the code can execute. Value of 200, limits it to every 200ms.

        jaws.context.mozImageSmoothingEnabled = true # Smoothing, see documentation.
        jaws.preventDefaultKeys(["up","down","left","right","space"]) # Array of keys we will tell jaws to be looking for.

        console.timeEnd "setup" # Timer End
    update: -> # Called every game tick
        if jaws.pressed("left") # Check if we've pressed any keys
            @player.move(-32,0) # Move appropriately
        if jaws.pressed("right")
            @player.move(32,0)
        if jaws.pressed("up")
            @player.move(0,-32)
        if jaws.pressed("down")
            @player.move(0,32)
        else if jaws.pressed("space")
            console.log("Player is now at the co-ordinates (#{@player.x},#{@player.y})")

        # For now this is how we are ensuring our player does not leave the map.
        # Buffer 16, as our tiles are 32x32, and our anchor point for a player is in the center.
        # The buffer is taken from you tile dimensions, not the image dimensions.
        @viewport.forceInsideVisibleArea @player, 16
        @viewport.centerAround @player # Focus the viewpoint around the player

    draw: -> # Called every game tick after update
        jaws.clear() # Clear the screen
        
        @viewport.drawTileMap @tiles # Draw the tiles, based upon the viewport. This will ensure we don't draw all the tiles every tick.
        @viewport.draw @player # Draw the player, based upon the viewport.


jaws.unpack() # Unpack jaws into global 
jaws.assets.add('/img/wall.png','/img/player.png') # Add any images we've used.
jaws.start(gameState) # Start our game using the level gameState

module.exports = gameState # CommonJS module.