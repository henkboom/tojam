local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

assert(number, 'missing player argument')

self.tags.player = true

-- used for step tracking
local last_pos = self.transform.pos

local player_facing = v2(1, 0)
-- distance travelled since last step
local step_progress = 0

local popup_timer = 0
local popup_queue = {}

-- initialize tracked attributes
attributes = {}
for _, v in ipairs(game.c.condition_types) do
  attributes[v] = 0
end
for _, v in ipairs(game.c.consequence_types) do
  attributes[v] = 0
end
attributes["health"] = 100

function update()
  if attributes.point >= 100 and #popup_queue <= 1 then
    queue_popup({'popup', text='VICTORY!', color={1, 1, 0}})
  end
  --attributes.point = attributes.point + 1
  -- movement
  local direction =
    game.camera.transform_direction_from_screen(
      game.controls.get_direction(number))

  local sign = attributes.speed >= 0 and 1 or -1
  local speed_multiplier = 1 + sign * math.sqrt(sign * attributes.speed)
                           * game.c.player_speed_offset
  local speed = math.max(game.c.player_min_speed,
  game.c.player_base_speed * speed_multiplier)

  self.character.move(direction, speed)

  -- step tracking
  local distance_travelled = v2.mag(self.transform.pos - last_pos)
  last_pos = self.transform.pos
  step_progress = step_progress + distance_travelled
  while step_progress >= game.c.player_step_distance do
    step_progress = step_progress - game.c.player_step_distance
    attributes.step = attributes.step + 1
    game.rules.register_event(self, 'step')
  end

  -- jumping
  if game.controls.button_pressed(number, 'jump') and self.character.can_jump() then
    self.character.jump()
    attributes["jump"] = attributes["jump"] + 1
  elseif not game.controls.button_held(number, 'jump') then
    self.character.reset_jump()
  end

  -- attack
  if game.controls.button_pressed(number, 'action') then
    self.character.attack()
  end
  
  popup_timer = math.max(popup_timer - 1, 0)
  if popup_timer <= 0 and #popup_queue > 0 then
    dequeue_popup()
  end
	
	if self.billboard.finished_jerking() then
		self.billboard.image = game.resources.player_sprites[number].stand
	else
		self.billboard.image = game.resources.player_sprites[number].attack
	end	
end

function draw_debug()
  if game.keyboard.key_held(string.byte('`')) then
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
end

function queue_popup(popup)
  table.insert(popup_queue, popup)
end

function dequeue_popup()
  game.actors.new(game.blueprints.popup,
        {'transform', pos=self.transform.pos, height=self.transform.height},
        popup_queue[1])
  popup_timer = 20 / #popup_queue
  table.remove(popup_queue, 1)
end

game.collision.add_collider(self, 'attack_hitbox', function (other, correction)
  if self ~= other.attack_hitbox.source then
    self.character.do_knockback(v2.norm(correction))
    attributes["health"] = attributes["health"] - 1
    game.rules.register_event(self, "damage")
    other.attack_hitbox.hit = true
    game.resources.sfx["damage"]:play(1)
    self.billboard.flash({1, 0, 0})
  end
end)
