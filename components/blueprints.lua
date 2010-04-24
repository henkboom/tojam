collision = require 'dokidoki.collision'
v2 = require 'dokidoki.v2'

character = game.make_blueprint('character',
  {'transform', height=0},
  {'billboard', image = game.resources.sprites.character},
  {'tag', tags={'action'}},
  {'collider', poly=collision.make_rectangle(16, 16)},
  {'character'})

local octagon_hitbox = {}
for i = 1, 8 do
  table.insert(octagon_hitbox,
    v2(math.cos(i*2*math.pi/8), math.sin(i*2*math.pi/8))*16)
end
octagon_hitbox = collision.make_polygon(octagon_hitbox)

attack_hitbox = game.make_blueprint('attack_hitbox',
  {'transform'},
  {'tag', tags={'action'}},
  {'collider', poly=octagon_hitbox},
  {'attack_hitbox'})
