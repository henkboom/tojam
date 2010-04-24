local gl = require 'gl'

game.actors.new_generic('camera_component', function ()
  function draw()
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    gl.glOrtho(0, 800, 0, 600, 1, -1)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
  end
end)
