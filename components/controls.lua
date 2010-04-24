local v2 = require 'dokidoki.v2'

function get_direction(player)
  local keys = game.c.keys[player]

  local left = game.keyboard.key_held(keys.left)
  local right = game.keyboard.key_held(keys.right)
  local down = game.keyboard.key_held(keys.down)
  local up = game.keyboard.key_held(keys.up)

  local direction = v2((right and 1 or 0) - (left and 1 or 0),
                       (up and 1 or 0)    - (down and 1 or 0))

  if direction ~= v2.zero then
    direction = v2.norm(direction)
  end
  return direction
end

function action_pressed(player)
  return game.keyboard.key_pressed(game.c.keys[player].action)
end

function action_down(player)
  return game.keyboard.key_down(game.c.keys[player].action)
end

function jump_pressed(player)
  return game.keyboard.key_pressed(game.c.keys[player].jump)
end

function jump_down(player)
  return game.keyboard.key_down(game.c.keys[player].jump)
end

