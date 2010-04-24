-- action.lua
-- controls the action gameplay. pauses during voting.

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
        game.voting.start()
      end
    end
  end
end)
