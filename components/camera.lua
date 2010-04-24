local gl = require 'gl'
local glu = require 'glu'
local v2 = require 'dokidoki.v2'

function do_billboard_transform(x, y, z)
  gl.glTranslated(x, y, z)
  gl.glRotated(-135, 0, 1, 0)
  gl.glRotated(-45,  1, 0, 0)
end

local control_x = v2.norm(v2(1, -1))
function transform_controls(direction)
  return v2.rotate_to(direction, control_x)
end

game.actors.new_generic('camera_component', function ()
  function draw()
    gl.glEnable(gl.GL_DEPTH_TEST)
    gl.glDepthFunc(gl.GL_LESS)
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    glu.gluPerspective(45, 4/3, 1, 1000)
    glu.gluLookAt(-8*16, 16*16, -8*16,
                  8*16, 0, 8*16,
                  0, 1, 0)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
  end

  function draw_debug()
    gl.glDisable(gl.GL_DEPTH_TEST)
  end
end)
