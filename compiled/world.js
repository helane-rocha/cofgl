// Generated by CoffeeScript 1.6.3
(function() {
  var World, root;

  World = (function() {
    function World(spaceShip) {
      this.spaceShip = spaceShip;
      this.shader = cofgl.game.geometry.shader;
      this.bgColor = cofgl.floatColorFromHex('#F2F3DC');
      this.vbo = cofgl.makeQuadVBO();
      this.spaceShip.world = this;
      /*
      @background = new cofgl.FrameBufferObject
      @background.texture.name = "uBackground"
      @background.texture.unit = 1
      backgroundShader = cofgl.resmgr.resources['shaders/hyperbolic_bg']
      cofgl.withContext [@background, backgroundShader], =>
        cofgl.clear @bgColor
        @vbo.draw()
      */

    }

    World.prototype.update = function(dt) {};

    World.prototype.draw = function() {
      var dir, p, q,
        _this = this;
      q = this.spaceShip.q;
      p = this.spaceShip.p;
      dir = this.spaceShip.dir;
      cofgl.clear(this.bgColor);
      return cofgl.withContext([this.shader, this.spaceShip.texture], function() {
        _this.shader.uniform2f("uq", q.x, q.y);
        _this.shader.uniform2f("up", p.x, p.y);
        _this.shader.uniform2f("udir", dir.x, dir.y);
        return _this.vbo.draw();
      });
    };

    return World;

  })();

  root = self.cofgl != null ? self.cofgl : self.cofgl = {};

  root.World = World;

}).call(this);
