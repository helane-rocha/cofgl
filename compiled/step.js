// Generated by CoffeeScript 1.6.3
(function() {
  var euclidStep, kleinStep, poincareStep, root, solveSystem;

  solveSystem = function(a, b, c, d, f) {
    var b2, delta, den, g, h, p1, p2, sqdelta;
    b2 = b * b;
    g = a * f - c * d;
    h = a * c + d * f;
    den = 2.0 * b2 * (c * c + f * f);
    delta = b2 * (b2 * b2 - 4.0 * g * g - 4.0 * b2 * h);
    sqdelta = Math.sqrt(delta);
    p1 = b2 * b * c + 2.0 * b * f * g;
    p2 = b2 * b * f - 2.0 * b * c * g;
    switch (false) {
      case c === 0.0:
        return [(p1 - c * sqdelta) / den, (p2 - f * sqdelta) / den, (p1 + c * sqdelta) / den, (p2 + f * sqdelta) / den];
      default:
        if (f === 0.0) {
          return [a / b, d / b, a / b, d / b];
        } else {
          return [a / b, (p2 + f * sqdelta) / den, a / b, (p2 - f * sqdelta) / den];
        }
    }
  };

  euclidStep = function(q, p, dir, h) {
    q.x = q.x + h * p.x / 2.0;
    q.y = q.y + h * p.y / 2.0;
    if (q.x > 1.0) {
      q.x = q.x - 2.0;
    }
    if (q.x < -1.0) {
      q.x = q.x + 2.0;
    }
    if (q.y > 1.0) {
      q.y = q.y - 2.0;
    }
    if (q.y < -1.0) {
      q.y = q.y + 2.0;
    }
    return [q, p, dir];
  };

  poincareStep = function(q, p, dir, h) {
    var D, D2h, a, b, c, d, dqx, dqy, f, _ref;
    D = 1.0 - q.x * q.x - q.y * q.y;
    D2h = D * D * h;
    a = D * D2h * p.x;
    b = 8.0 * D;
    c = 16.0 * q.x;
    d = D * D2h * p.y;
    f = 16.0 * q.y;
    _ref = solveSystem(a, b, c, d, f), dqx = _ref[0], dqy = _ref[1];
    q.x = q.x + dqx;
    q.y = q.y + dqy;
    p.x = 8.0 * dqx / D2h;
    p.y = 8.0 * dqy / D2h;
    if (q.x > 1) {
      q.x = q.x - 2.0;
    }
    if (q.x < -1) {
      q.x = q.x + 2.0;
    }
    if (q.y > 1) {
      q.y = q.y - 2.0;
    }
    if (q.y < -1) {
      q.y = q.y + 2.0;
    }
    return [q, p, dir];
  };

  kleinStep = function(q, p, dir, h) {
    var D, D2h, a, b, c, d, dqx, dqy, dx, dy, f, n, n2, px, py, _ref;
    D = 1.0 + q.x * q.x + q.y * q.y;
    D2h = D * D * h;
    a = D * D2h * p.x;
    b = 8.0 * D;
    c = -16.0 * q.x;
    d = D * D2h * p.y;
    f = -16.0 * q.y;
    _ref = solveSystem(a, b, c, d, f), dqx = _ref[0], dqy = _ref[1];
    q.x = q.x + dqx;
    q.y = q.y + dqy;
    p.x = 8.0 * dqx / D2h;
    p.y = 8.0 * dqy / D2h;
    n = q.x * q.x + q.y * q.y;
    if (n > 1.0) {
      n2 = n * n;
      a = (q.x * q.x - q.y * q.y) / n2;
      b = 2.0 * q.x * q.y / n2;
      c = b;
      d = -a;
      px = p.x * a + p.y * b;
      py = p.x * c + p.y * d;
      p.x = px;
      p.y = py;
      dx = dir.x * a + dir.y * b;
      dy = dir.x * c + dir.y * d;
      dir.x = dx;
      dir.y = dy;
      q = new cofgl.Complex(-q.x / n2, -q.y / n2);
    }
    return [q, p, dir];
  };

  root = self.cofgl != null ? self.cofgl : self.cofgl = {};

  root.poincareStep = poincareStep;

  root.kleinStep = kleinStep;

  root.euclidStep = euclidStep;

}).call(this);