require 'dokidoki.module' [[]]

local kernel = require 'dokidoki.kernel'

local the_game = require 'the_game'

local args = {}
for _, a in ipairs(arg) do
  args[a] = true
end

if not args['--windowed'] then
  kernel.set_fullscreen(true)
end

kernel.set_video_mode(800, 600)
kernel.start_main_loop(the_game.make())
