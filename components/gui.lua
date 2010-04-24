local gl = require 'gl'

width = 800
height = 600

game.actors.new_generic('gui_component', function ()
  function draw_setup ()
    gl.glClear(gl.GL_DEPTH_BUFFER_BIT)
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    gl.glOrtho(0, width, 0, height, 1, -1)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
  end
end)
