local v2 = require 'dokidoki.v2'

self.tags.character = true

local movement_direction = v2.zero
local attack_direction = v2(1, 0)

local vertical_vel = 0
local jump_timer = false

local grounded = false

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

function jump()
  if grounded then
    vertical_vel = 4
    jump_timer = 0
  end
end

function reset_jump()
  jump_timer = false
end

function hit_ground()
  vertical_vel = math.max(0, vertical_vel)
  grounded = "yes"
end

function update()
  if grounded == "maybe" then
    grounded = false
  end

  if not jump_timer or jump_timer > 10 then
    vertical_vel = vertical_vel - 0.3
  else
    vertical_vel = vertical_vel - 0.1
  end
  if jump_timer then
    jump_timer = jump_timer + 1
  end
  self.transform.height = self.transform.height + vertical_vel

  grounded = "maybe"
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)
