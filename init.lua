require 'dokidoki.module' [[]]

local kernel = require 'dokidoki.kernel'

local the_game = require 'the_game'

kernel.set_video_mode(800, 600)
kernel.start_main_loop(the_game.make())
