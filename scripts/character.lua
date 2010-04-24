local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

assert(player, 'missing player argument')

local character_facing = v2(1, 0)
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
    game.camera.transform_controls(game.controls.get_direction(player))

  local speed_multiplier =
    1 + math.sqrt(attributes.speed) * game.c.character_speed_offset
  local speed = game.c.character_base_speed * speed_multiplier
  local vel = direction * speed
  self.transform.pos = self.transform.pos + vel

  -- step tracking
  step_progress = step_progress + v2.mag(vel)
  while step_progress >= game.c.character_step_distance do
    step_progress = step_progress - game.c.character_step_distance
    game.rules.register_event(self, 'step')
  end

  -- orientation
  if direction ~= v2.zero then
    character_facing = direction
  end

  -- attack
  if game.controls.button_pressed(player, 'action') then
    print('attack', character_facing)
    local offset = character_facing * 8
    game.actors.new(game.blueprints.attack_hitbox,
      {'transform', pos=self.transform.pos + offset},
      {'attack_hitbox', player=player, offset=offset})
  end
end

function draw_debug()
  local lines = {}
  for k,v in pairs(attributes) do
    table.insert(lines, string.format("%s: %s\n", k, v))
  end

  gl.glPushMatrix()
  gl.glTranslated(self.transform.pos.x+10, self.transform.pos.y+8, 0)
  graphics.draw_text(game.resources.font, table.concat(lines))
  gl.glPopMatrix()
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
