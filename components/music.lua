local mixer = require 'mixer'
local channel

function play()
  channel = game.resources.music:play(0.5, 0.5, 0)
end

function stop()
  if channel then
    mixer.channel_stop(channel)
    channel = nil
  end
end
