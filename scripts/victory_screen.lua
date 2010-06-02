local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local kernel = require 'dokidoki.kernel'

local the_game = require 'the_game'

assert(player, 'missing player argument')

local time = 0
local dead_countdown

function update()
  time = time + 1
  if time > 180 and
     (game.controls.button_pressed(1, 'action') or
      game.controls.button_pressed(2, 'action') or
      game.controls.button_pressed(3, 'action') or
      game.controls.button_pressed(4, 'action')) then
     if not dead_countdown then
       dead_countdown = 60
     end
  end

  if dead_countdown then
    dead_countdown = dead_countdown - 1
    if dead_countdown < 0 then
      game.music.stop()
      kernel.switch_scene(the_game.make())
    end
  end
end

function draw_gui()
  gl.glColor4d(0.2, 0.2, 0.2, time/60)
  gl.glBegin(gl.GL_QUADS)
  gl.glVertex2d(0, 0)
  gl.glVertex2d(800, 0)
  gl.glVertex2d(800, 600)
  gl.glVertex2d(0, 600)
  gl.glEnd()

  gl.glColor4d(1, 1, 1, time/60)

  gl.glPushMatrix()
  gl.glTranslated(400, 400, 0)
  game.resources.sprites.victory:draw()
  gl.glTranslated(0, -200, 0)
  gl.glScaled(4, 4, 4)
  game.resources.player_sprites[player].attack:draw()
  gl.glPopMatrix()

  if dead_countdown then
    gl.glColor4d(0, 0, 0, 1-dead_countdown/60)
    gl.glBegin(gl.GL_QUADS)
    gl.glVertex2d(0, 0)
    gl.glVertex2d(800, 0)
    gl.glVertex2d(800, 600)
    gl.glVertex2d(0, 600)
    gl.glEnd()
  end

  gl.glColor3d(1, 1, 1)
end
