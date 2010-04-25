local v2 = require 'dokidoki.v2'

local spawn_order = { 'pickup', 'pickup', 'pickup', 'pickup', 'enemy' }
local spawn_time = { 3, 3, 3, 3 }

local order_index = 1
local time_index = 1

local time_before_spawn = 3

local function spawn()
	local entity_to_spawn = spawn_order[order_index]
	if order_index < table.getn(spawn_order) then
		order_index = order_index + 1
	else
		order_index = 1
	end
	
	local spawn_pos = v2(math.floor(math.random(1, 16)), math.floor(math.random(1, 16)))
	
	if #game.actors.get(entity_to_spawn) < 4 then
		game.actors.new(game.blueprints[entity_to_spawn],
			{'transform', pos=v2(spawn_pos.x * 16 - 8, spawn_pos.y * 16 - 8), height=game.level.get_height(spawn_pos.x, spawn_pos.y) + 8})
	end

	if time_index < table.getn(spawn_time) then
		time_before_spawn = spawn_time[time_index]
		time_index = time_index + 1
	else
		time_before_spawn = 2
	end	
end

function update()
	if time_before_spawn <= 0 then
		spawn()
	else
		time_before_spawn = time_before_spawn - 1/60
	end
end