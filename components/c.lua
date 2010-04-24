-- constants, accessed as game.c.___

debug_line_count = 5

action_duration = 60 * 5

-- character settings

character_speed = 2

-- controls for the four players
keys = {
  {
    left = glfw.KEY_LEFT,
    right = glfw.KEY_RIGHT,
    up = glfw.KEY_UP,
    down = glfw.KEY_DOWN,
    jump = string.byte('Z'),
    action = string.byte('X')
  },
  {
    left = string.byte('J'),
    right = string.byte('L'),
    up = string.byte('I'),
    down = string.byte('K'),
    jump = string.byte('G'),
    action = string.byte('H')
  },
}
