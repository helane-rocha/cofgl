keyMapping =
  38:     'thurst'        # Arrow Up
  37:     'rotateLeft'      # Arrow Left
  39:     'rotateRight'     # Arrow Right


class Game
  constructor: ->
    @actions = {}
    for code, action of keyMapping
      @actions[action] = false

  initGame: ->
    @spaceShip = new cofgl.SpaceShip
    @world = new cofgl.World(@spaceShip)
    @processor = new cofgl.Processor cofgl.resmgr.resources['shaders/nothing']


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
      console.debug "rotateRight"
      @spaceShip.rotateRight()
    if @actions.rotateLeft
      console.debug "rotateLeft"
      @spaceShip.rotateLeft()
    if @actions.thurst
      console.debug "thurst"
      @spaceShip.thurst()
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


$(document).ready ->
  debug = cofgl.getRuntimeParameter('debug') == '1'
  initEngineAndGame '#viewport', debug


root = self.cofgl ?= {}
root.game = null
root.debugPanel = null
root.resmgr = null
root.engine = null
