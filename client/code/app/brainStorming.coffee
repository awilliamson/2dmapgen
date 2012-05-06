
width = 100
height = 100

randInt = (min,max) ->
	Math.floor(Math.random()*(max-min+1))+min

@h = 100
@w = 100

@data = (cell = 1 for x in [0...@w] for y in [0...@h]) # Generate a fully walled map
console.log(@data)

maxSize = [Math.floor(width/10),Math.floor(height/10)]; console.log(maxSize)
minSize = [1,1]

@roomCenter = [Math.ceil(width/2),Math.ceil(height/2)]; console.log(@roomCenter)
randSize = [randInt(minSize[0],maxSize[0]), randInt(minSize[1],maxSize[1])]; console.log(randSize)
upperLeft = [@roomCenter[0]-randSize[0],@roomCenter[1]-randSize[1]]; console.log(upperLeft)
@data = (cell = 0 for x in [upperLeft[0]..upperLeft[0]+2*[randSize[0]]] for y in [upperLeft[1]..upperLeft[1]+2*[randSize[1]]])
console.log(@data)