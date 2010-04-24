local gl = require 'gl'

game.actors.new_generic('level_component', function ()
  function draw()
    gl.glBegin(gl.GL_LINE_LOOP)
    gl.glVertex3d(0, 0, 0)
    gl.glVertex3d(0, 0, 16*16)
    gl.glVertex3d(16*16, 0, 16*16)
    gl.glVertex3d(16*16, 0, 0)
    gl.glEnd()
  end
end)
