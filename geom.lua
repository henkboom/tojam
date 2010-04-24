require 'dokidoki.module' [[ make_octagon ]]

local v2 = require 'dokidoki.v2'
local collision = require 'dokidoki.collision'

function make_octagon(radius)
  local octagon = {}
  for i = 1, 8 do
    table.insert(octagon,
      v2(math.cos((i+0.5)*2*math.pi/8), math.sin((i+0.5)*2*math.pi/8)) * radius)
  end
  return collision.make_polygon(octagon)
end

return get_module_exports()
