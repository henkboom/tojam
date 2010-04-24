local v2 = require 'dokidoki.v2'

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
  return game.keyboard.key_held(game.c.keys[player][type])
end

function button_pressed(player, type)
  return game.keyboard.key_pressed(game.c.keys[player][type])
end

