local gl = require 'gl'
local v2 = require 'dokidoki.v2'
local graphics = require 'dokidoki.graphics'

assert(text, 'missing text argument')
assert(color, 'missing color argument')

local MAX_TIMER = 60
local timer = MAX_TIMER
local vel = v2(0.3, 0.1)
local rising = 0.05

function update()
  self.transform.pos = self.transform.pos + vel
  self.transform.height = self.transform.height + rising
  rising = rising + 0.03
  timer = timer - 1
  
  if timer < 0 then
    self.dead = true
  end
end

function draw()
  gl.glPushMatrix()
  game.camera.do_billboard_transform(
    self.transform.pos.y,
    self.transform.height,
    self.transform.pos.x)
  gl.glTranslated(game.resources.font_string_width(text) / -2, 0, 0)
  gl.glColor4d(color[1], color[2], color[3], timer / MAX_TIMER)
  graphics.draw_text(game.resources.font, text)
  gl.glColor3d(1, 1, 1, 1)
  gl.glPopMatrix()
end