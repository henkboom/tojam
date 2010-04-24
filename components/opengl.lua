local gl = require 'gl'
local kernel = require 'dokidoki.kernel'

width = 800
height = 600

game.actors.new_generic('opengl_setup', function ()
  draw_setup = function ()
    kernel.set_ratio(width / height)

    gl.glClearColor(0, 0, 0, 0)
    gl.glClear(gl.GL_COLOR_BUFFER_BIT + gl.GL_DEPTH_BUFFER_BIT)

    gl.glEnable(gl.GL_BLEND)
    gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
    gl.glAlphaFunc(gl.GL_GREATER, 0)
    gl.glEnable(gl.GL_ALPHA_TEST)
  end
end)
