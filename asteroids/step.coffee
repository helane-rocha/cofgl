
# a = b x - c (x^2 + y^2)
# d = e y - f (x^2 + y^2)
# e = b
solveSystem = (a, b, c, d, f) ->
  #console.debug "a = #{a}"
  #console.debug "b = #{b}"
  #console.debug "c = #{c}"
  #console.debug "d = #{d}"
  #console.debug "f = #{f}"
  b2 = b*b
  g = a*f - c*d
  h = a*c + d*f
  den = 2.0*b2*(c*c + f*f)
  #console.debug "den = #{den}"
  delta = b2*(b2*b2 - 4.0*g*g - 4.0*b2*h)
  #console.debug "delta = #{delta}"
  sqdelta = Math.sqrt(delta)
  #console.debug "sqdelta = #{sqdelta}"
  p1 = b2*b*c + 2.0*b*f*g
  p2 = b2*b*f - 2.0*b*c*g
  switch
    when c != 0.0 then [
      (p1 - c*sqdelta)/den,
      (p2 - f*sqdelta)/den,
      (p1 + c*sqdelta)/den,
      (p2 + f*sqdelta)/den,
    ]
    else
      if f==0.0
        [a/b, d/b, a/b, d/b]
      else
        [a/b, (p2 + f*sqdelta)/den, a/b, (p2 - f*sqdelta)/den]

euclidStep = (q, p, dir, h) ->
  q.x = q.x + h*p.x/2.0
  q.y = q.y + h*p.y/2.0
  if q.x > 1.0
    q.x = q.x - 2.0
  if q.x < -1.0
    q.x = q.x + 2.0
  if q.y > 1.0
    q.y = q.y - 2.0
  if q.y < -1.0
    q.y = q.y + 2.0
  [q, p, dir]

poincareStep = (q, p, dir, h) ->
  #console.debug "q = #{q}"
  #console.debug "p = #{p}"
  #console.debug "h = #{h}"
  D = 1.0 - q.x*q.x - q.y*q.y
  D2h = D*D*h
  a = D*D2h*p.x
  b = 8.0*D
  c = 16.0*q.x
  d = D*D2h*p.y
  #e = 8.0*D 
  f = 16.0*q.y
  [dqx, dqy] = solveSystem(a, b, c, d, f)
  q.x = q.x + dqx
  q.y = q.y + dqy
  p.x = 8.0*dqx/D2h
  p.y = 8.0*dqy/D2h
  if q.x > 1
    q.x = q.x - 2.0
  if q.x < -1
    q.x = q.x + 2.0
  if q.y > 1
    q.y = q.y - 2.0
  if q.y < -1
    q.y = q.y + 2.0
  [q, p, dir]

kleinStep = (q, p, dir, h) ->
  #console.debug "q = #{q}"
  #console.debug "p = #{p}"
  #console.debug "h = #{h}"
  D = 1.0 + q.x*q.x + q.y*q.y
  D2h = D*D*h
  a = D*D2h*p.x
  b = 8.0*D
  c = -16.0*q.x
  d = D*D2h*p.y
  #e = 8.0*D 
  f = -16.0*q.y
  [dqx, dqy] = solveSystem(a, b, c, d, f)
  q.x = q.x + dqx
  q.y = q.y + dqy
  p.x = 8.0*dqx/D2h
  p.y = 8.0*dqy/D2h
  n = q.x*q.x + q.y*q.y
  if n > 1.0
    n2 = n*n
    a = (q.x*q.x-q.y*q.y)/n2
    b = 2.0*q.x*q.y/n2
    c = b
    d = -a
    px = p.x*a + p.y*b
    py = p.x*c + p.y*d
    p.x = px
    p.y = py
    dx = dir.x*a + dir.y*b
    dy = dir.x*c + dir.y*d
    dir.x = dx
    dir.y = dy
    q = new cofgl.Complex(-q.x/n2,-q.y/n2)
  [q, p, dir]

root = self.cofgl ?= {}
root.poincareStep = poincareStep
root.kleinStep = kleinStep
root.euclidStep = euclidStep