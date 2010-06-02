local glfw = require 'glfw'

-- constants, accessed as game.c.___

-- game flow
action_duration = 60 * 20

-- level settings
level_size = 16
level_tile_size = 16

-- player settings
player_base_speed = 1
player_speed_offset = 0.2
player_min_speed = 0.2
player_step_distance = 48

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
  {
    up = string.byte('1'),
		action = string.byte('2')
  },
  {
    up = string.byte('3'),
		action = string.byte('4')
  },
}

-- rule categories
condition_qualifiers = {"each", "most", "least"}
condition_types = {"step", "teacup", "health", "point", "jump"}
consequence_qualifiers = {"adds", "removes"}
consequence_types = {"teacup", "health", "point", "speed"}
types_plural = {step = "steps", teacup = "teacups", health = "health",
                point = "points", speed = "speed", jump="jumps"}
consequence_quantities = {most = 10, least = 10, each = 1}

round_qualifiers = {most = true, least = true}
event_qualifiers = {each = true}

each_impossible = {health = true, point = true}

attr_ranges = {
  teacup={min=-math.huge, max=math.huge},
  health={min=-math.huge, max=math.huge},
  point={min=-math.huge, max=math.huge},
  speed={min=-30, max=30}
}
