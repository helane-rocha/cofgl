class Complex
  constructor: (@x=0, @y=0) ->
    @magnitude = @x*@x + @y*@y
 
  plus: (c2) ->
    new Complex(
      @x + c2.x,
      @y + c2.y
    )
 
  times: (c2) ->
    new Complex(
      @x*c2.x - @y*c2.y,
      @x*c2.y + @y*c2.x
    )
 
  negation: ->
    new Complex(
      -1 * @x,
      -1 * @y
    )
 
  inverse: ->
    throw Error "no inverse" if @magnitude is 0
    new Complex(
      @x / @magnitude,
      -1.0 * @y / @magnitude
    )
 
  toString: ->
    return "#{@x}" if @y == 0
    return "#{@y}i" if @x == 0
    if @y > 0
      "#{@x} + #{@y}i"
    else
      "#{@x} - #{-1.0 * @y}i"

root = self.cofgl ?= {}
root.Complex = Complex
