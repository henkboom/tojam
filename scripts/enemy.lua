local v2 = require 'dokidoki.v2'

local enemy_facing = v2(1, 0)
local health = 10
local target = nil
local speed = 1
local attack_cooldown = 0

local death_duration = 30
local death_timer = death_duration

function update()
  attack_cooldown = math.max(0, attack_cooldown - 1)

  if health < 1 then
    die()
    return
  end

  if target and self.transform.pos ~= target.transform.pos then
    local direction = v2.norm(target.transform.pos - self.transform.pos)
    self.character.move(direction, speed)

    --attack if in range
    if v2.mag(self.transform.pos - target.transform.pos) < 20 and attack_cooldown == 0 then
      self.character.attack()
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
    self.billboard.color[4] = death_timer/death_duration
  end
end

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
