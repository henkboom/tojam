local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local geom = require 'geom'

character = game.make_blueprint('character',
  {'transform', height=8},
  {'billboard', image = game.resources.sprites.character},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(8)},
  {'character'})

attack_hitbox = game.make_blueprint('attack_hitbox',
  {'transform'},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(16)},
  {'attack_hitbox'})
