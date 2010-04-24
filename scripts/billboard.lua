local gl = require 'gl'

assert(image, 'missing image argument')

function draw()
  gl.glPushMatrix()
  game.camera.do_billboard_transform(
    self.transform.pos.y,
    self.transform.height,
    self.transform.pos.x, 0)

  -- slooooow and stupid rotation:
  local f = self.transform.facing
  gl.glRotated(180/math.pi * math.atan2(f.y, f.x), 0, 0, 1)

  gl.glScaled(self.transform.scale_x, self.transform.scale_y, 0)

  gl.glColor3d(1, 1, 1)
  image:draw()

  gl.glPopMatrix()
end
