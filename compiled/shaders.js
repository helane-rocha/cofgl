// Generated by CoffeeScript 1.6.3
(function() {
  var Shader, lastSourceID, loadShader, loadShaderSource, onShaderError, preprocessSource, root, shaderFromSource, shaderReverseMapping, shaderSourceCache,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  lastSourceID = 0;

  shaderSourceCache = {};

  shaderReverseMapping = {};

  onShaderError = function(type, log, stage, filename) {
    var dummy, errorFilename, level, line, lineno, lines, match, message, sourceID, _i, _len;
    if (filename == null) {
      filename = '<string>';
    }
    filename = cofgl.autoShortenFilename(filename);
    console.error("Shader error when " + stage + " " + type + " " + filename);
    console.debug("Shader debug information:");
    lines = log.split(/\r?\n/);
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      match = line.match(/(\w+):\s+(\d+):(\d+):\s*(.*)$/);
      if (match) {
        dummy = match[0], level = match[1], sourceID = match[2], lineno = match[3], message = match[4];
        errorFilename = cofgl.autoShortenFilename(shaderReverseMapping[sourceID]);
        console.warn("[" + level + "] " + errorFilename + ":" + lineno + ": " + message);
      } else {
        console.log(line);
      }
    }
    throw "Abort: Unable to load shader '" + filename + "' because of errors";
  };

  shaderFromSource = function(type, source, filename) {
    var gl, log, shader;
    if (filename == null) {
      filename = null;
    }
    gl = cofgl.engine.gl;
    shader = gl.createShader(gl[type]);
    source = "#define " + type + "\n" + source;
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      log = gl.getShaderInfoLog(shader);
      onShaderError(type, log, 'compiling', filename);
    }
    return shader;
  };

  preprocessSource = function(filename, source, sourceID, callback) {
    var checkDone, insertLocation, line, lines, match, processingDone, shadersToInclude, _i, _len, _ref;
    lines = [];
    shadersToInclude = 0;
    processingDone = false;
    checkDone = function() {
      if (processingDone && shadersToInclude === 0) {
        return callback(lines.join('\n'));
      }
    };
    lines.push('#line 0 ' + sourceID);
    _ref = source.split(/\r?\n/);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      if (match = line.match(/^\s*#include\s+"(.*?)"\s*$/)) {
        insertLocation = lines.length;
        lines.push(null);
        shadersToInclude++;
        (function(insertLocation) {
          return loadShaderSource(cofgl.joinFilename(filename, match[1]), function(source) {
            lines[insertLocation] = source + '\n#line ' + insertLocation + ' ' + sourceID;
            shadersToInclude--;
            return checkDone();
          });
        })(insertLocation);
      } else {
        lines.push(line);
      }
    }
    processingDone = true;
    return checkDone();
  };

  loadShaderSource = function(filename, callback) {
    var cached, process;
    process = function(source) {
      var entry;
      entry = shaderSourceCache[filename];
      if (!entry) {
        shaderSourceCache[filename] = entry = [source, lastSourceID++];
        shaderReverseMapping[entry[1]] = filename;
      }
      return preprocessSource(filename, source, entry[1], callback);
    };
    cached = shaderSourceCache[filename];
    if (cached != null) {
      return process(cached[0]);
    } else {
      console.debug("Loading shader source '" + (cofgl.autoShortenFilename(filename)) + "'");
      return $.ajax({
        url: filename,
        dataType: 'text',
        success: process
      });
    }
  };

  loadShader = function(filename, callback) {
    return loadShaderSource(filename, function(source) {
      return callback(new Shader(source, filename));
    });
  };

  Shader = (function(_super) {
    __extends(Shader, _super);

    Shader.withStack('shader');

    function Shader(source, filename) {
      var gl, log;
      if (filename == null) {
        filename = null;
      }
      gl = cofgl.engine.gl;
      this.prog = gl.createProgram();
      this.vertexShader = shaderFromSource('VERTEX_SHADER', source, filename);
      this.fragmentShader = shaderFromSource('FRAGMENT_SHADER', source, filename);
      gl.attachShader(this.prog, this.vertexShader);
      gl.attachShader(this.prog, this.fragmentShader);
      gl.linkProgram(this.prog);
      this.attribCache = {};
      this.uniformCache = {};
      this._uniformVersion = 0;
      if (!gl.getProgramParameter(this.prog, gl.LINK_STATUS)) {
        log = gl.getProgramInfoLog(this.prog);
        onShaderError('PROGRAM', log, 'linking', filename);
      }
      console.debug("Compiled shader from '" + filename + "' ->", this);
    }

    Shader.prototype.getUniformLocation = function(name) {
      var _base;
      return (_base = this.uniformCache)[name] != null ? (_base = this.uniformCache)[name] : _base[name] = cofgl.engine.gl.getUniformLocation(this.prog, name);
    };

    Shader.prototype.getAttribLocation = function(name) {
      var _base;
      return (_base = this.attribCache)[name] != null ? (_base = this.attribCache)[name] : _base[name] = cofgl.engine.gl.getAttribLocation(this.prog, name);
    };

    Shader.prototype.uniform1i = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform1i(loc, value);
      }
    };

    Shader.prototype.uniform1f = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform1f(loc, value);
      }
    };

    Shader.prototype.uniform2f = function(name, value1, value2) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform2f(loc, value1, value2);
      }
    };

    Shader.prototype.uniform2fv = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform2fv(loc, value);
      }
    };

    Shader.prototype.uniform3fv = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform3fv(loc, value);
      }
    };

    Shader.prototype.uniform4fv = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniform4fv(loc, value);
      }
    };

    Shader.prototype.uniformMatrix3fv = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniformMatrix3fv(loc, false, value);
      }
    };

    Shader.prototype.uniformMatrix4fv = function(name, value) {
      var loc;
      loc = this.getUniformLocation(name);
      if (loc) {
        return cofgl.engine.gl.uniformMatrix4fv(loc, false, value);
      }
    };

    Shader.prototype.bind = function() {
      return cofgl.engine.gl.useProgram(this.prog);
    };

    Shader.prototype.unbind = function() {
      return cofgl.engine.gl.useProgram(null);
    };

    Shader.prototype.destroy = function() {
      var gl;
      gl = cofgl.engine.gl;
      gl.destroyProgram(this.prog);
      gl.destroyShader(this.vertexShader);
      return gl.destroyShader(this.fragmentShader);
    };

    return Shader;

  })(cofgl.ContextObject);

  root = self.cofgl != null ? self.cofgl : self.cofgl = {};

  root.Shader = Shader;

  root.loadShader = loadShader;

}).call(this);