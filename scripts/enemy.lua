local v2 = require 'dokidoki.v2'

local enemy_facing = v2(1, 0)
local health = 10
local target = nil
local speed = 1
local attack_cooldown = 0
local death_timer = 30

function update()
  attack_cooldown = math.max(0, attack_cooldown - 1)

  if health < 1 then
    die()
    return
  end

  if target and self.transform.pos ~= target.transform.pos then
    local direction = v2.norm(target.transform.pos - self.transform.pos)
    local vel = direction * speed
    self.transform.pos = self.transform.pos + vel
    if direction ~= v2.zero then
      enemy_facing = direction
    end
    
    --attack if in range
    if v2.mag(self.transform.pos - target.transform.pos) < 20 and attack_cooldown == 0 then
      local offset = enemy_facing * 8
      game.actors.new(game.blueprints.attack_hitbox,
        {'transform', pos=self.transform.pos + offset},
        {'attack_hitbox', source=self, offset=offset})
      attack_cooldown = 40
    end
  end
end

function die()
  death_timer = death_timer - 1
  if death_timer < 0 then
    self.dead = true
  else
    self.billboard.image = game.resources.sprites.enemy_death
    self.billboard.color[4] = self.billboard.color[4] or 1
    self.billboard.color[4] = self.billboard.color[4] - 0.01
  end
end

game.collision.add_collider(self, 'character', function (other, correction)
  self.transform.pos = self.transform.pos + correction/2
  other.transform.pos = other.transform.pos - correction/2
end)

game.collision.add_collider(self, 'attack_hitbox', function (other, correction)
  if self ~= other.attack_hitbox.source then
    self.transform.pos = self.transform.pos + correction
    other.attack_hitbox.hit = true
    game.resources.sfx["damage"]:play(1)
    target = other.attack_hitbox.source
    health = health - 1
    self.billboard.flash({1, 0, 0})
  end
end)