RESOURCES = [
  ['shaders/hyperbolic', 'assets/shaders/hyperbolic.glsl'],
  ['shaders/hyperbolic_bg', 'assets/shaders/hyperbolic_bg.glsl'],
  ['shaders/elliptic', 'assets/shaders/elliptic.glsl'],
  ['shaders/euclidean', 'assets/shaders/euclidean.glsl'],
  ['shaders/postprocess', '../assets/shaders/postprocess.glsl'],
  ['shaders/nothing', '../assets/shaders/nothing.glsl'],
  ['space/spaceship', 'assets/textures/spaceship.png'],
  ['space/background', 'assets/textures/angrybird.png'],
]


makeDefaultResourceManager = ->
  resmgr = new cofgl.ResourceManager
  resmgr.addFromList RESOURCES
  resmgr


root = self.cofgl ?= {}
root.makeDefaultResourceManager = makeDefaultResourceManager
