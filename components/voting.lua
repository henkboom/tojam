local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

-- voting.lua
-- controls the voting phase

local COLUMN_SPACING = 7
local LINE_SPACING = 4
local LINE_HEIGHT = 7

local voting = false

local categories = {
	game.rules.condition_qualifier,
	game.rules.condition_type, 
	game.rules.consequence_qualifier,
	game.rules.consequence_type
}
local current_category
local current_choices = { 1, 1, 1, 1 }
local voting_player = 1

local first_update
function start()
  print('started voting')
  voting = true
	
	-- reset current category
	current_category = 1
	
	-- change the electing player
	-- voting_player = voting_player + 1
	-- if voting_player > NUM_PLAYER then voting_player = 1 end
	
	first_update = true -- eeh
end

game.actors.new_generic('voting_component', function ()

	local function sign(x)
		return x>0 and 1 or x<0 and -1 or 0
	end

	local last_direction = v2.zero
  function update()
    if not voting then return end
		
		if game.controls.action_pressed(1) then
			voting = false
			game.action.resume()
			return
		end
		
		-- hacky differential state stuff
		local direction = game.controls.get_direction(1)
		local delta_direction = direction - last_direction
		last_direction = direction
		delta_direction.x = sign(delta_direction.x) * (direction.x == 0 and 0 or 1)
		delta_direction.y = sign(delta_direction.y) * (direction.y == 0 and 0 or 1)
		
		if not first_update then
			current_category = current_category + delta_direction.x
			if current_category == 0 then current_category = 4 end
			if current_category == table.getn(categories)+1 then current_category = 1 end
			
			current_choices[current_category] = current_choices[current_category] - delta_direction.y
			if current_choices[current_category] == 0 then current_choices[current_category] = table.getn(categories[current_category]) end
			if current_choices[current_category] == table.getn(categories[current_category])+1 then current_choices[current_category] = 1 end
		else
			first_update = false
		end
  end
	
	local function draw_line(text)
		graphics.draw_text(game.resources.font, text)	
		gl.glTranslated(0, -10, 0)
  end	
	
  local function draw_choice(category)
		gl.glPushMatrix()
		
		local choices = categories[category]
		local current_choice = current_choices[category]
		
		gl.glTranslated(COLUMN_SPACING / 2, 0, 0)
		
		-- evaluate size of column
		local max_width = 0
		for index, choice in ipairs(choices) do
			max_width = math.max(max_width, game.resources.font_string_width(choice))
		end
		local total_height = table.getn(choices) * (8 + LINE_SPACING) -- where 10 is graphics.font_map_line_height(game.resources.font)
		
		-- highlight the back for selected category
		gl.glColor3d(0.25, 0.25, 0.25)
		if category == current_category then
			gl.glBegin(gl.GL_QUADS)
				gl.glVertex2d(-1, 0)  
				gl.glVertex2d(-1, -total_height)				
				gl.glVertex2d(max_width+1, -total_height) 
				gl.glVertex2d(max_width+1, 0) 
			gl.glEnd()
		end
		gl.glColor3d(1, 1, 1)
		
		if category == current_category then
			local choice_count = table.getn(choices)
			for i = 0, choice_count-1 do
				local index = ((i + (current_choice-1)) % (choice_count)) + 1
				local choice = choices[index]
			
				gl.glTranslated(0, -LINE_SPACING / 2, 0)
				if i == 0 then
					-- highlight it
					gl.glBegin(gl.GL_QUADS)
						gl.glVertex2d(-1, 1)  
						gl.glVertex2d(-1, -LINE_HEIGHT-1)				
						gl.glVertex2d(max_width+1, -LINE_HEIGHT-1) 
						gl.glVertex2d(max_width+1, 1) 
					gl.glEnd()
					gl.glColor3d(0, 0, 0)
				end
				graphics.draw_text(game.resources.font, choice)
				gl.glTranslated(0, -LINE_HEIGHT - LINE_SPACING / 2, 0)
				gl.glColor3d(1, 1, 1)
			end
		else
			gl.glTranslated(0, -LINE_SPACING / 2, 0)
			graphics.draw_text(game.resources.font, choices[current_choice])
		end
		
		gl.glPopMatrix()
		gl.glTranslated(max_width + COLUMN_SPACING / 2, 0, 0)
  end
  
  function draw()
		if not voting then return end
		
		gl.glPushMatrix()
		gl.glTranslated(2, game.opengl_2d.height - 40, 0)
		gl.glScaled(2, 2, 2)
		draw_line('player voting...')
		draw_line('')
		for i = 1,4 do
			draw_choice(i)
		end
		gl.glPopMatrix()
  end

end)
