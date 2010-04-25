local mixer = require 'mixer'
local channel
local stop_timer

function play()
  channel = game.resources.music:play(0.5, 0.5, 0)
end

function stop()
  if channel then
    mixer.channel_fade_to(channel, 1, 0)
    stop_timer = 60 + 10
  end
end

game.actors.new_generic('music_component', function ()
  function update()
    if stop_timer then
      stop_timer = stop_timer - 1
      if stop_timer == 0 then
        stop_timer = nil
        print('stopping')
        mixer.channel_stop(channel)
        channel = nil
      end
    end
  end
end)
