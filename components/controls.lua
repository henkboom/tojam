local glfw = require 'glfw'
local gl = require 'gl'
local v2 = require 'dokidoki.v2'

local joystick_indices = { glfw.JOYSTICK_1, glfw.JOYSTICK_2, glfw.JOYSTICK_3, glfw.JOYSTICK_4 }

local old_joystick_states = {{}, {}, {}, {}}
local joystick_states = {{}, {}, {}, {}}

for i = 1,4 do
	old_joystick_states[i].up = false; joystick_states[i].up = false
	old_joystick_states[i].down = false; joystick_states[i].down = false
	old_joystick_states[i].left = false; joystick_states[i].left = false
	old_joystick_states[i].right = false; joystick_states[i].right = false
	old_joystick_states[i].jump = false; joystick_states[i].jump = false
	old_joystick_states[i].action = false; joystick_states[i].action = false
end

function get_direction(player)
  local keys = game.c.keys[player]

  local left = button_held(player, 'left')
  local right = button_held(player, 'right')
  local down = button_held(player, 'down')
  local up = button_held(player, 'up')

  local direction = v2((right and 1 or 0) - (left and 1 or 0),
                       (up and 1 or 0)    - (down and 1 or 0))

  if direction ~= v2.zero then
    direction = v2.norm(direction)
  end
  return direction
end

function button_held(player, type)
	return joystick_states[player][type] or game.keyboard.key_held(game.c.keys[player][type])
end

function button_pressed(player, type)
	return (joystick_states[player][type] and not old_joystick_states[player][type]) or game.keyboard.key_pressed(game.c.keys[player][type])
end


game.actors.new_generic('controls', function ()
	-- find the connected controllers
	local connected = {}
	for i = 1, 4 do
		if (glfw.GetJoystickParam(joystick_indices[i], glfw.PRESENT) == gl.GL_TRUE) then
			connected[#connected + 1] = joystick_indices[i]
		end
	end

	local function update_joystick(player, controller)
		for i, s in pairs(joystick_states[player]) do
			old_joystick_states[player][i] = s
		end
		
		if glfw.GetJoystickParam(connected[controller], glfw.PRESENT) == gl.GL_FALSE then return end
	
		local buttons = glfw.GetJoystickButtons(connected[controller], 3)
		local axis = glfw.GetJoystickPos(connected[controller], 2)
		
		joystick_states[player].left = axis[1] < -0.5
		joystick_states[player].right = axis[1] > 0.5
		joystick_states[player].up = axis[2] > 0.5
		joystick_states[player].down = axis[2] < -0.5
		joystick_states[player].jump = buttons[1] == glfw.PRESS
		joystick_states[player].action = (buttons[2] == glfw.PRESS) or (buttons[3] == glfw.PRESS)
	end

  function update_setup()	
		local j = 0
		for i = 1, 4 do
			j = j + 1
			if j > #connected then return	end	
			update_joystick(i, j)
		end
  end
end)
