keyMapping =
  40:     'break'        # Arrow Down
  38:     'thurst'        # Arrow Up
  37:     'rotateLeft'      # Arrow Left
  39:     'rotateRight'     # Arrow Right


class Game
  constructor: ->
    @actions = {}
    for code, action of keyMapping
      @actions[action] = false

  restart: (geometry) ->
    @geometry = @geometries[geometry]
    @spaceShip = new cofgl.SpaceShip()
    @world = new cofgl.World(@spaceShip)

  initGame: ->
    @processor = new cofgl.Processor cofgl.resmgr.resources['shaders/nothing']
    @geometries =
      euclidean:
        shader: cofgl.resmgr.resources['shaders/euclidean']
        step: cofgl.euclidTorusStep
      hyperbolic:
        shader: cofgl.resmgr.resources['shaders/hyperbolic']
        step: cofgl.poincareBitorusStep
      elliptic:
        shader: cofgl.resmgr.resources['shaders/elliptic']
        step: cofgl.kleinStep
    @geometry = @geometries.euclidean
    @spaceShip = new cofgl.SpaceShip()
    @world = new cofgl.World(@spaceShip)


  initEventHandlers: ->
    $(window)
      .bind 'keydown', (event) =>
        this.onKeyDown event
      .bind 'keyup', (event) =>
        this.onKeyUp event

  onKeyDown: (event) ->
    action = keyMapping[event.which]
    if action?
      @actions[action] = true
      false

  onKeyUp: (event) ->
    action = keyMapping[event.which]
    if action?
      @actions[action] = false
      false

  run: ->
    cofgl.resmgr.wait =>
      this.initGame()
      this.initEventHandlers()
      this.mainloop()

  mainloop: ->
    cofgl.engine.mainloop (dt) =>
      this.updateGame dt
      this.render()

  updateGame: (dt) ->
    if @actions.rotateRight
      #console.debug "rotateRight"
      @spaceShip.rotateRight()
    if @actions.rotateLeft
      #console.debug "rotateLeft"
      @spaceShip.rotateLeft()
    if @actions.thurst
      #console.debug "thurst"
      @spaceShip.thurst()
    if @actions.break
      #console.debug "break"
      @spaceShip.break()
    @spaceShip.update dt
    @world.update dt

  render: ->
#    {gl} = cofgl.engine
    cofgl.clear()
    @processor.push()
    @world.draw()
    @processor.pop()


initEngineAndGame = (selector, debug) ->
  canvas = $(selector)[0]

  cofgl.debugPanel = new cofgl.DebugPanel()
  cofgl.engine = new cofgl.Engine(canvas, debug)
  cofgl.resmgr = cofgl.makeDefaultResourceManager()
  cofgl.game = new Game
  cofgl.game.run()
  $("input[name='geometry']").change( -> cofgl.game.restart this.value )


$(document).ready ->
  debug = cofgl.getRuntimeParameter('debug') == '1'
  initEngineAndGame '#viewport', debug


root = self.cofgl ?= {}
root.game = null
root.geometries = null
root.debugPanel = null
root.resmgr = null
root.engine = null
