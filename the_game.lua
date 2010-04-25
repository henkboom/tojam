require 'dokidoki.module' [[ make ]]

local glfw = require 'glfw'
local game = require 'dokidoki.game'
local v2 = require 'dokidoki.v2'

function make()
  return game.make_game(
    {'update_setup', 'update', 'collision_check', 'update_cleanup'},
    {'draw_setup', 'draw', 'draw_debug', 'draw_gui', 'draw_debug_gui'},
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

      local tojam_splash
      local no_fun_splash
      local start_game
      
      function tojam_splash()
          game.actors.new(game.blueprints.splash,
            {'transform', pos=v2(0, 0), height=100, scale_x = 0.23, scale_y = 0.23},
            {'billboard', image = game.resources.sprites.tojam},
            {'splash', timer = 100, when_dead = no_fun_splash})
      end

      function no_fun_splash()
          game.actors.new(game.blueprints.splash,
            {'transform', pos=v2(0, 0), height=100, scale_x = 0.3, scale_y = 0.3},
            {'billboard', image = game.resources.sprites.no_fun},
            {'splash', timer = 100, when_dead = start_game})
      end

      function start_game()
          game.init_component('level')
          game.level.load(game.resources.level)

          game.actors.new(game.blueprints.player,
            {'transform', pos=v2(20, 20), height=10},
            {'player', number=1})
          game.actors.new(game.blueprints.player,
            {'transform', pos=v2(200, 120)},
            {'player', number=2})
          game.actors.new(game.blueprints.player,
            {'transform', pos=v2(20, 120)},
            {'player', number=3})
    			game.actors.new(game.blueprints.player,
            {'transform', pos=v2(200, 20)},
            {'player', number=4})
			
      		game.actors.new(game.blueprints.spawner)

          game.action.resume()
      end
      
      --display splash screens in order
      tojam_splash()
    end)
end



return get_module_exports()
