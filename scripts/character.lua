local v2 = require 'dokidoki.v2'

assert(player, 'missing player argument')

local character_facing = v2(1, 0)

local attributes = {}
for _, v in ipairs(game.c.condition_types) do
  attributes[v] = {0, 0, 0, 0}
end
for _, v in ipairs(game.c.consequence_types) do
  attributes[v] = attributes[v] or {0, 0, 0, 0}
end

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
    local offset = character_facing * 8
    game.actors.new(game.blueprints.attack_hitbox,
      {'transform', pos=self.transform.pos + offset},
      {'attack_hitbox', player=player, offset=offset})
  end
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)

game.collision.add_collider(self, 'attack_hitbox', function (other, correction)
  if player ~= other.attack_hitbox.player then
    self.transform.pos = self.transform.pos + correction * 2
  end
end)
