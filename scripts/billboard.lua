local gl = require 'gl'

assert(image, 'missing image argument')

color = color or {1, 1, 1}

local flash_timer = 0
local flash_color = {0, 0, 0}

local jerk_timer = 0

local flipped = false

function update()
  flash_timer = math.max(0, flash_timer - 1)
  jerk_timer = math.max(0, jerk_timer - 1)
end

function draw()
  gl.glPushMatrix()
  game.camera.do_billboard_transform(
    self.transform.pos.y,
    self.transform.height,
    self.transform.pos.x)

  -- slooooow and stupid rotation:
  local f = self.transform.facing
  gl.glRotated(180/math.pi * math.atan2(f.y, f.x), 0, 0, 1)

  gl.glScaled((flipped and -1 or 1) * self.transform.scale_x,
              self.transform.scale_y, 0)

  if jerk_timer > 0 then
    gl.glTranslated(4, 0, 0)
    gl.glRotated(-60, 0, 0, 1)
    gl.glTranslated(-2, 0, 0)
  end

  if flash_timer > 0 then
    gl.glColor4d(flash_color[1], flash_color[2], flash_color[3], flash_color[4] or 1)
  else
    gl.glColor4d(color[1], color[2], color[3], color[4] or 1)
  end
  
  image:draw()
  gl.glColor3d(1, 1, 1)

  gl.glPopMatrix()
end

function flash(color)
  flash_timer = 5
  flash_color = color
end

function jerk()
  jerk_timer = 5
end

function set_flipped(f)
  flipped = f
end
