local v2 = require 'dokidoki.v2'

assert(player, 'missing player argument')

local character_facing = v2(1, 0)

function update()
  -- movement
  local direction = game.controls.get_direction(player)
  self.transform.pos = self.transform.pos + direction * game.c.character_speed

  if direction ~= v2.zero then
    character_facing = direction
  end

  -- attack
  if game.controls.action_pressed(player) then
    print('attack', character_facing)
  end
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)
