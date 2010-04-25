local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

local geom = require 'geom'

player = game.make_blueprint('player',
  {'transform', height=0},
  {'billboard', image = game.resources.sprites.player},
	{'drop_shadow'},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(8)},
  {'character'},
  {'player'})

enemy = game.make_blueprint('enemy',
  {'transform', height=0},
  {'billboard', image = game.resources.sprites.enemy},
  {'tag', tags={'action', 'enemy'}},
	{'drop_shadow'},
  {'collider', poly=geom.make_octagon(8)},
  {'character'},
  {'enemy'})

attack_hitbox = game.make_blueprint('attack_hitbox',
  {'transform'},
  {'tag', tags={'action'}},
  {'collider', poly=geom.make_octagon(16)},
  {'attack_hitbox'})

popup = game.make_blueprint('popup',
  {'transform'},
  {'popup'})

spawner = game.make_blueprint('spawner', 
	{'tag', tags={'action'}},
	{'spawner'})

pickup = game.make_blueprint('pickup', 
	{'tag', tags={'action', 'pickup'}},
	{'transform'},
	{'drop_shadow'},
	{'collider', poly=geom.make_octagon(8)},
  {'billboard', image = game.resources.sprites.pickup},
	{'pickup'})	

splash = game.make_blueprint('splash',
  {'transform'},
  {'billboard'},
  {'splash'})
	
hud = game.make_blueprint('hud',
  {'hud'})