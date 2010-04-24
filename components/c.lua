-- constants, accessed as game.c.___

-- game flow
action_duration = 60 * 20

-- level settings

level_size = 16
level_tile_size = 16

-- character settings

character_base_speed = 2
character_speed_offset = 0.2
character_min_speed = 0.2
character_step_distance = 32

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

-- rule categories
condition_qualifiers = {"each", "most", "least"}
condition_types = {"step", "teacup", "damage", "point"}
consequence_qualifiers = {"add", "remove"}
consequence_types = {"teacup", "damage", "point", "speed"}
types_plural = {step = "steps", teacup = "teacups", damage = "damage",
                point = "points", speed = "speed"}
consequence_quantities = {most = 10, least = 10, each = 1}

round_qualifiers = {most = true, least = true}
event_qualifiers = {each = true}
