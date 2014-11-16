// Generated by CoffeeScript 1.6.3
(function() {
  var SpaceShip, root, step_iterations;

  step_iterations = 5;

  SpaceShip = (function() {
    function SpaceShip() {
      this.texture = cofgl.Texture.fromImage(cofgl.resmgr.resources['space/spaceship'], {
        mipmaps: true,
        filtering: 'LINEAR'
      });
      this.q = new cofgl.Complex(0.0, 0.0);
      this.p = new cofgl.Complex(0.0, 0.0);
      this.dir = new cofgl.Complex(1.0, 0.0);
      this.left = new cofgl.Complex(Math.cos(0.05), Math.sin(0.05));
      this.right = new cofgl.Complex(Math.cos(-0.05), Math.sin(-0.05));
    }

    SpaceShip.prototype.update = function(dt) {
      var i, _i, _ref;
      for (i = _i = 1; 1 <= step_iterations ? _i <= step_iterations : _i >= step_iterations; i = 1 <= step_iterations ? ++_i : --_i) {
        _ref = cofgl.game.geometry.step(this.q, this.p, this.dir, dt / step_iterations), this.q = _ref[0], this.p = _ref[1], this.dir = _ref[2];
      }
      this.dir = this.dir.plus(this.p);
      return this.dir.normalize();
    };

    SpaceShip.prototype.rotateLeft = function() {
      this.p = this.p.times(this.left);
      return this.dir = this.dir.times(this.left);
    };

    SpaceShip.prototype.rotateRight = function() {
      this.p = this.p.times(this.right);
      return this.dir = this.dir.times(this.right);
    };

    SpaceShip.prototype.thurst = function() {
      var v;
      v = new cofgl.Complex(this.dir.x / 10.0, this.dir.y / 10.0);
      return this.p = this.p.plus(v);
    };

    SpaceShip.prototype["break"] = function() {
      var v;
      v = new cofgl.Complex(-this.dir.x / 10.0, -this.dir.y / 10.0);
      return this.p = this.p.plus(v);
    };

    return SpaceShip;

  })();

  root = self.cofgl != null ? self.cofgl : self.cofgl = {};

  root.SpaceShip = SpaceShip;

}).call(this);
