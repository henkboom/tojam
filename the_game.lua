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
      game.init_component('exit_handler')
      game.exit_handler.trap_esc = true
      game.init_component('keyboard')
      game.init_component('opengl_2d')
      game.opengl_2d.background_color = {0, 0, 0}
      game.opengl_2d.width = 800
      game.opengl_2d.height = 600

      game.init_component('blueprints')
      game.init_component('resources')
      game.init_component('c')

      game.init_component('action')
      game.init_component('voting')

      game.action.resume()
    end)
end

return get_module_exports()
