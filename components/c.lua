-- constants, accessed as game.c.___

debug_line_count = 5

action_duration = 60 * 2

-- controls for the four players
keys = {
  {left = glfw.KEY_LEFT, right = glfw.KEY_RIGHT, up = glfw.KEY_UP,
   down = glfw.KEY_DOWN, jump = string.byte('z'), action = string.byte('x')},
  {left = glfw.KEY_LEFT, right = glfw.KEY_RIGHT, up = glfw.KEY_UP,
   down = glfw.KEY_DOWN, jump = string.byte('z'), action = string.byte('x')},
  {left = glfw.KEY_LEFT, right = glfw.KEY_RIGHT, up = glfw.KEY_UP,
   down = glfw.KEY_DOWN, jump = string.byte('z'), action = string.byte('x')},
  {left = glfw.KEY_LEFT, right = glfw.KEY_RIGHT, up = glfw.KEY_UP,
   down = glfw.KEY_DOWN, jump = string.byte('z'), action = string.byte('x')},
}
