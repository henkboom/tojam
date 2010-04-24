collision = require 'dokidoki.collision'

character = game.make_blueprint('character',
  {'transform'},
  {'sprite', image = game.resources.sprites.character},
  {'tag', tags={'action'}},
  {'collider', poly=collision.make_rectangle(16, 16)},
  {'character'})
