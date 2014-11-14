
class SpaceShip
  constructor: ->
    @texture = cofgl.Texture.fromImage cofgl.resmgr.resources['space/spaceship'], {
        mipmaps: true,
        filtering: 'LINEAR'
      }
    @q = new cofgl.Complex(0.0,0.0)
    @p = new cofgl.Complex(0.0,0.0)
    @dir = 0.0

  update: (dt) ->
    #console.debug "q = #{@q}"
    #console.debug "p = #{@p}"
    [@q, @p] = cofgl.poincareStep(@q, @p, dt)

  rotateLeft: ->
    @dir = @dir + 0.05

  rotateRight: ->
    @dir = @dir - 0.05

  thurst: ->
    v = this.dirVec()
    v.x = v.x/10.0
    v.y = v.y/10.0
    @p = @p.plus (v)
    console.debug "p = #{@p}"

  dirVec: ->
    new cofgl.Complex(Math.cos(@dir), Math.sin(@dir))


root = self.cofgl ?= {}
root.SpaceShip = SpaceShip
