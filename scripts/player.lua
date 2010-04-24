local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

assert(number, 'missing player argument')

local player_facing = v2(1, 0)
-- distance travelled since last step
local step_progress = 0

-- initialize tracked attributes
attributes = {}
for _, v in ipairs(game.c.condition_types) do
  attributes[v] = 0
end
for _, v in ipairs(game.c.consequence_types) do
  attributes[v] = 0
end

function update()
  -- movement
  local direction =
    game.camera.transform_controls(game.controls.get_direction(number))

  local sign = attributes.speed >= 0 and 1 or -1
  local speed_multiplier = 1 + sign * math.sqrt(sign * attributes.speed)
                               * game.c.player_speed_offset

  local speed = math.max(game.c.player_min_speed,
                         game.c.player_base_speed * speed_multiplier)
  local vel = direction * speed
  self.transform.pos = self.transform.pos + vel

  -- step tracking
  step_progress = step_progress + v2.mag(vel)
  while step_progress >= game.c.player_step_distance do
    step_progress = step_progress - game.c.player_step_distance
    attributes.step = attributes.step + 1
    game.rules.register_event(self, 'step')
  end

  -- orientation
  if direction ~= v2.zero then
    player_facing = direction
  end

  -- attack
  if game.controls.button_pressed(number, 'action') then
    print('attack', player_facing)
    local offset = player_facing * 8
    game.actors.new(game.blueprints.attack_hitbox,
      {'transform', pos=self.transform.pos + offset},
      {'attack_hitbox', source=self, offset=offset})
  end
end

function draw_debug()
  local lines = {}
  for k,v in pairs(attributes) do
    table.insert(lines, string.format("%s: %s\n", k, v))
  end

  gl.glPushMatrix()
  game.camera.do_billboard_transform(
    self.transform.pos.y,
    self.transform.height,
    self.transform.pos.x, 0)
  gl.glTranslated(10, 8, 0)
  graphics.draw_text(game.resources.font, table.concat(lines))
  gl.glPopMatrix()
end

game.collision.add_collider(self, 'player', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)

game.collision.add_collider(self, 'enemy', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)

game.collision.add_collider(self, 'attack_hitbox', function (other, correction)
  if self ~= other.attack_hitbox.source then
    self.transform.pos = self.transform.pos + correction
    attributes["damage"] = attributes["damage"] + 1
    game.rules.register_event(self, "damage")
    other.attack_hitbox.hit = true
    game.resources.sfx["damage"]:play(1)
    self.billboard.flash({1, 0, 0})
  end
end)
