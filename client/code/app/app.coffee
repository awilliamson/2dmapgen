Dungeon = require '/dungeon'

class window.World
    constructor: (@res, @width, @height)->
        @map = new Dungeon(@width,@height) # Generate a new map Object, given x and y.
        @bounds = new jaws.Rect(0,0,@width*@res,@height*@res) # Create a jaws.Rect, this will represent the bounds of our 'world'

        # Tiles #

        @tiles = new jaws.TileMap # Create a tilemap, this will be later used to render our walls. Ground is currently not a tilemap.
            size: [@width,@height] # Size set to the bounds of our map
            cell_size: [@res,@res] # Define how big each 'node' will be, in this instance it's 32x32, the size of our wall sprite.

        # Blocks

        @blocks = new jaws.SpriteList()
        @adj = new jaws.SpriteList()
        @floor = new jaws.SpriteList()

        for coord in @map.getCoordByType(1) # For each entry in the array responsible for walls.
            @blocks.push new jaws.Sprite # Make a new sprite, and push it.
                image: "/img/wall2.png" # Setup parameters for the Sprite, args can be found in jaws documentation.
                x: coord[0]*@res# Use the x,y co-ordinates from each entry, *32 as our sprites are 32x32 based, ensures correct spacing.
                y: coord[1]*@res

        for coord in @map.getCoordByType(0)
            @floor.push new jaws.Sprite
                image: "/img/floor.png"
                x: coord[0]*@res
                y: coord[1]*@res

        #Below is debug for adjacent cells.
        for coord in @map.getCoordByType(2)
            @adj.push new jaws.Sprite
                image: "/img/adj.png"
                x: coord[0]*@res
                y: coord[1]*@res

        @tiles.push(@blocks) #Push our blocks, 'walls', to this tileMap so we can render later.
        @tiles.push(@adj)

gameState = # Used to setup the game space for our level, several of these can be used for menu's etc.
    setup: -> # Called initially to setup all the level.
        console.time "setup" # Debug timer to see how long it takes to setup the level.

        @world = new World(32,100,100)

        @viewport = new jaws.Viewport
            max_x: @world.bounds.width
            max_y: @world.bounds.height # Make a new viewport

        #@anim = new jaws.Animation {sprite_sheet: "/img/16x16.png", frame_size: [16,16]}

        @player = new jaws.Sprite # Create a player
            image: "/img/player.png" # Setup parameters for the player. Player.png is 30x30, to avoid collision issues, and such.
            x: 16 + 50*32
            y: 16 + 50*32
            anchor: "center"

        @player.can_move = true

        @player.move = (x,y)-> # Responsible for moving our player, given move (x,y).

            if gameState.player.can_move

                @x += x # This will move our player along by x, note: Can also be a negative number.
                if app.world.tiles.atRect(gameState.player.rect()).length > 0 # Check collisions with out tileMap (just walls for now)
                    @x -= x #Negate the movement effects if we're gonna go into a wall.

                @y += y
                if app.world.tiles.atRect(gameState.player.rect()).length > 0
                    @y -= y

                setTimeout( 
                    -> 
                        gameState.player.can_move = true
                    , 150
                    )

        #@player.move = _.throttle @player.move, 100 # Throttle move so we don't fly along at however fast the code can execute. Value of 200, limits it to every 200ms.

        #jaws.context.mozImageSmoothingEnabled = true # Smoothing, see documentation.
        jwerty.key ["up","left","down","right","space","W","A","S","D"], false


        console.timeEnd "setup" # Timer End
    update: -> # Called every game tick
        #if @player.can_move is true ->
        if gameState.player.can_move is true
            jwerty.key "left/A", -> 
                gameState.player.move(-32,0); gameState.player.can_move = false
            jwerty.key "right/D", ->
                gameState.player.move(32,0); gameState.player.can_move = false
            jwerty.key "up/W", ->
                gameState.player.move(0,-32); gameState.player.can_move = false
            jwerty.key "down/S", ->
                gameState.player.move(0,32); gameState.player.can_move = false
            jwerty.key "space", ->
                console.log("Player is now at the co-ordinates (#{gameState.player.x},#{gameState.player.y})")

        # For now this is how we are ensuring our player does not leave the map.
        # Buffer 16, as our tiles are 32x32, and our anchor point for a player is in the center.
        # The buffer is taken from you tile dimensions, not the image dimensions.
        @viewport.forceInside @player, 16
        @viewport.centerAround @player # Focus the viewpoint around the player

    draw: -> # Called every game tick after update
        jaws.clear() # Clear the screen
        
        @viewport.drawTileMap @world.tiles # Draw the tiles, based upon the viewport. This will ensure we don't draw all the tiles every tick.
        @viewport.draw @player # Draw the player, based upon the viewport.

jaws.onload = ->
    jaws.unpack() # Unpack jaws into global 
    jaws.assets.add(['/img/wall2.png','/img/player.png','/img/adj.png','/img/floor.png']) # Add any images we've used.
    jaws.start(gameState) # Start our game using the level gameState

jaws.onload()

module.exports = gameState # CommonJS module.