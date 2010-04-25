local v2 = require 'dokidoki.v2'

self.tags.character = true

local attack_direction = v2(1, 0)

local vertical_vel = 0
local jump_timer = false

local grounded = false

local last_pos = self.transform.pos
local direction = v2.zero

function move(new_direction, speed)
  if grounded then
    direction = (new_direction + direction*2)/3
  else
    direction = (new_direction + direction*9)/10
  end
  local vel = direction * speed
  self.transform.pos = self.transform.pos + vel
  if new_direction ~= v2.zero then
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
    game.resources.sfx["jump"]:play(1)
    game.rules.register_event(self, "jump")
  end
end

function reset_jump()
  jump_timer = false
end

function can_jump()
  return grounded
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

  -- cheap momentum, stops player from getting stuck on stuff :p
  self.transform.pos = self.transform.pos + (self.transform.pos - last_pos) * 0.2
  last_pos = self.transform.pos

  if grounded then grounded = "maybe" end
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)
