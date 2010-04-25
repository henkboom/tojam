local v2 = require 'dokidoki.v2'

self.tags.character = true

local movement_direction = v2.zero
local attack_direction = v2(1, 0)

function move(direction, speed)
  local vel = direction * speed
  self.transform.pos = self.transform.pos + vel
  if direction ~= v2.zero then
    attack_direction = direction
  end

  local screen_direction = game.camera.transform_direction_to_screen(direction)
  if screen_direction.x ~= 0 then
    self.billboard.set_flipped(screen_direction.x < 0)
  end
end

function attack()
  self.billboard.jerk()
  local offset = attack_direction * 8
  game.actors.new(game.blueprints.attack_hitbox,
    {'transform', pos=self.transform.pos + offset},
    {'attack_hitbox', source=self, offset=offset})
end

function update()
  self.transform.height = self.transform.height - 1
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)
