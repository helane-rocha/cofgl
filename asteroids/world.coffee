
class World
  constructor: (@spaceShip) ->
    @shader = cofgl.game.geometry.shader
    @bgColor = cofgl.floatColorFromHex '#F2F3DC'
    @vbo = cofgl.makeQuadVBO()
    @spaceShip.world = this
    ###
    @background = new cofgl.FrameBufferObject
    @background.texture.name = "uBackground"
    @background.texture.unit = 1
    backgroundShader = cofgl.resmgr.resources['shaders/hyperbolic_bg']
    cofgl.withContext [@background, backgroundShader], =>
      cofgl.clear @bgColor
      @vbo.draw()
    ###

  update: (dt) ->

  draw: ->
#   {gl} = cofgl.engine
    q = @spaceShip.q
    p = @spaceShip.p
    dir = @spaceShip.dir
    cofgl.clear @bgColor
#    cofgl.withContext [@shader, @spaceShip.texture, @background.texture], =>
    cofgl.withContext [@shader, @spaceShip.texture], =>
      @shader.uniform2f "uq", q.x, q.y
      @shader.uniform2f "up", p.x, p.y
      @shader.uniform2f "udir", dir.x, dir.y
      @vbo.draw()

root = self.cofgl ?= {}
root.World = World
