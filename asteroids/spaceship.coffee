
step_iterations = 5

class SpaceShip
  constructor: ->
    @texture = cofgl.Texture.fromImage cofgl.resmgr.resources['space/spaceship'], {
        mipmaps: true,
        filtering: 'LINEAR'
      }
    @q = new cofgl.Complex(0.0,0.0)
    @p = new cofgl.Complex(0.0,0.0)
    @dir = new cofgl.Complex(1.0,0.0)
    @left = new cofgl.Complex(Math.cos(0.05),Math.sin(0.05))
    @right = new cofgl.Complex(Math.cos(-0.05),Math.sin(-0.05))

  update: (dt) ->
    #console.debug "q = #{@q}"
    #console.debug "p = #{@p}"
    for i in [1 .. step_iterations]
      [@q, @p, @dir] = cofgl.game.geometry.step(@q, @p, @dir, dt/step_iterations)
    @dir.normalize()

  rotateLeft: ->
    @p = @p.times @left
    @dir = @dir.times @left

  rotateRight: ->
    @p = @p.times @right
    @dir = @dir.times @right

  thurst: ->
    v = new cofgl.Complex(@dir.x/10.0, @dir.y/10.0)
    @p = @p.plus (v)

  break: ->
    v = new cofgl.Complex(-(@dir.x)/10.0, -(@dir.y)/10.0)
    @p = @p.plus (v)


root = self.cofgl ?= {}
root.SpaceShip = SpaceShip
