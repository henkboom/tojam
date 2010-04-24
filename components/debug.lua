local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local kernel = require 'dokidoki.kernel'

local lines = {}

game.actors.new_generic('debug_component', function ()
  function draw_debug_gui()
    gl.glPushMatrix()
    --gl.glTranslated(2, game.gui.height - 2, 0)
    --gl.glScaled(2, 2, 2)
    --graphics.draw_text(game.resources.font,
    --  string.format('fps: %.1f', kernel.get_framerate()))
    gl.glPopMatrix()
  end
end)
