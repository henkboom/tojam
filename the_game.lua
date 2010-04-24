require 'dokidoki.module' [[ make ]]

local glfw = require 'glfw'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

function make()
  return game.make_game(
    {'update_setup', 'update', 'collision_check', 'update_cleanup'},
    {'draw_setup', 'draw', 'draw_gui', 'draw_debug'},
    function (game)
      glfw.SetWindowTitle('tojam')
      math.randomseed(os.time())

      -- standard components
      game.init_component('exit_handler')
      game.exit_handler.trap_esc = true
      game.init_component('keyboard')

      -- information components
      game.init_component('c')
      game.init_component('resources')
      game.init_component('blueprints')
      game.init_component('debug')

      -- general components
      game.init_component('collision')
      game.init_component('controls')

      -- drawing components
      game.init_component('opengl')
      game.init_component('camera')
      game.init_component('gui')

      -- game logic components
			game.init_component('rules')
      game.init_component('action')
      game.init_component('voting')

      game.init_component('level')

      game.actors.new(game.blueprints.character,
        {'transform', pos=v2(0, 0)},
        {'character', player=1})
      game.actors.new(game.blueprints.character,
        {'transform', pos=v2(200, 120)},
        {'character', player=2})

      game.action.resume()
    end)
end

return get_module_exports()
