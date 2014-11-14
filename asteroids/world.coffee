
class World
  constructor: (@spaceShip) ->
    @shader = cofgl.resmgr.resources['shaders/hyperbolic']
    @bgColor = cofgl.floatColorFromHex '#F2F3DC'
    @vbo = cofgl.makeQuadVBO()

  update: (dt) ->

  draw: ->
#   {gl} = cofgl.engine
    q = @spaceShip.q
    p = @spaceShip.p
    dir = @spaceShip.dirVec()
    cofgl.clear @bgColor
    cofgl.withContext [@shader,@spaceShip.texture], =>
      @shader.uniform2f "uq", q.x, q.y
      @shader.uniform2f "up", p.x, p.y
      @shader.uniform2f "udir", dir.x, dir.y
      @vbo.draw()


root = self.cofgl ?= {}
root.World = World
