local gl = require 'gl'

local level

function load(level_data)
  level = {}
  for i = 1, 16 do
    level[i] = {}
    for j = 1, 16 do
      level[i][j] = level_data:byte(257-(i+(j-1)*16)) / 4
    end
  end
end

local function get_height(i, j)
  return level[i] and level[i][j]
end

game.actors.new_generic('level_component', function ()
  function collision_check()
    for _, a in ipairs(game.actors.get('character')) do
      local mini = math.floor((a.transform.pos.x-8)/16) + 1
      local maxi = math.ceil((a.transform.pos.x+8)/16)
      local minj = math.floor((a.transform.pos.y-8)/16) + 1
      local maxj = math.ceil((a.transform.pos.y+8)/16)

      local height = math.max(
        get_height(mini, minj) or 0,
        get_height(maxi, minj) or 0,
        get_height(mini, maxj) or 0,
        get_height(maxi, maxj) or 0)

      a.transform.height = math.max(a.transform.height, height + 8)
    end
  end

  function draw()
    -- tops
    gl.glColor3d(1, 1, 1)
    game.resources.textures.grass:enable()
    gl.glBegin(gl.GL_QUADS)
    for i = 1, 16 do
      for j = 1, 16 do
        local height = get_height(i, j)
        local shadow = (get_height(i+1, j) or 0) > height
        local z = (i-1)*16
        local x = (j-1)*16
        gl.glTexCoord2d(0, 1); gl.glVertex3d(x,    height, z)
        if shadow then gl.glColor3d(0.8, 0.8, 0.8) end
        gl.glTexCoord2d(1, 1); gl.glVertex3d(x,    height, z+16)
        gl.glTexCoord2d(1, 0); gl.glVertex3d(x+16, height, z+16)
        if shadow then gl.glColor3d(1, 1, 1) end
        gl.glTexCoord2d(0, 0); gl.glVertex3d(x+16, height, z)
      end
    end
    gl.glEnd()
    game.resources.textures.grass:disable()

    -- edges
    game.resources.textures.cliff:enable()
    gl.glBegin(gl.GL_QUADS)
    for i = 1, 16 do
      for j = 1, 16 do
        local height = get_height(i, j)
        local z = (i-1)*16
        local x = (j-1)*16

        -- left edge
        gl.glColor3d(0.8, 0.8, 0.8)
        local left = get_height(i-1, j) or math.huge
        if left < height then
          gl.glTexCoord2d(left/16,   1); gl.glVertex3d(x+16, left,   z)
          gl.glTexCoord2d(height/16, 1); gl.glVertex3d(x,    left,   z)
          gl.glTexCoord2d(height/16, 0); gl.glVertex3d(x,    height, z)
          gl.glTexCoord2d(left/16,   0); gl.glVertex3d(x+16, height, z)
        end
        gl.glColor3d(1, 1, 1)

        -- right edge
        local right = get_height(i, j-1) or math.huge
        if right < height then
          gl.glTexCoord2d(right/16,  1); gl.glVertex3d(x, right,  z)
          gl.glTexCoord2d(height/16, 1); gl.glVertex3d(x, right,  z+16)
          gl.glTexCoord2d(height/16, 0); gl.glVertex3d(x, height, z+16)
          gl.glTexCoord2d(right/16,  0); gl.glVertex3d(x, height, z)
        end
      end
    end
    gl.glEnd()
    game.resources.textures.cliff:disable()
  end
end)

