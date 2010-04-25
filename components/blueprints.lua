local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local geom = require 'geom'

player = game.make_blueprint('player',
  {'transform', height=0},
  {'billboard', image = game.resources.sprites.player},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(8)},
  {'character'},
  {'player'})

enemy = game.make_blueprint('enemy',
  {'transform', height=0},
  {'billboard', image = game.resources.sprites.enemy},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(8)},
  {'character'},
  {'enemy'})

attack_hitbox = game.make_blueprint('attack_hitbox',
  {'transform'},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(16)},
  {'attack_hitbox'})
