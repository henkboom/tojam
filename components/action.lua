-- action.lua
-- controls the action gameplay. pauses during voting.

local graphics = require 'dokidoki.graphics'
local gl = require 'gl'

local time = 0
local paused = true

-- returns all action actors which need to be paused
local function get_action_actors()
  return game.actors.get('action')
end

-- called initially and after voting is done
function resume()
  print('resuming action')
  time = 0
  paused = false
  for _, a in ipairs(get_action_actors()) do
    a.paused = false
  end
end

-- pauses all action actors
local function pause_all()
  paused = true
  for _, a in ipairs(get_action_actors()) do
    a.paused = true
  end
end

game.actors.new_generic('action_component', function ()
  function update()
    if not paused then
      time = time + 1
      if time == game.c.action_duration then
        print('pausing action')
        pause_all()
        game.rules.end_round()
        game.rules.check_victory()
        game.voting.start()
      end
    end
  end
  function draw_gui()
    if not paused then
      gl.glPushMatrix()
      gl.glTranslated(750, 40.0, 0)
      local countdown = math.ceil((game.c.action_duration - time) / 60)
      local scale = 5
      if countdown <= 5 then
        scale = scale + (6 - countdown) * 10
        gl.glTranslated((6 - countdown) * -50, (6 - countdown) * 80, 0)
      end
      gl.glScaled(scale, scale, 0)
      if countdown <= 10 then
        gl.glColor4d(1, 1, 1, (game.c.action_duration - time) % 60 / 60)
      end
      graphics.draw_text(game.resources.font, tostring(countdown))
      gl.glColor3d(1, 1, 1)
      gl.glPopMatrix()
    end
  end
end)
