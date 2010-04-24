local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

-- voting.lua
-- controls the voting phase

local BOX_MARGIN = 5
local EXISTING_RULES_WIDTH = 230
local INFO_BAR_HEIGHT = 30

local COLUMN_SPACING = 7
local LINE_SPACING = 4
local LINE_HEIGHT = 7

local PHASES = { none = 'none', choosing_rule = 'choosing_rule', voting = 'voting' }
local current_phase = PHASES.none

local categories = {
	game.c.condition_qualifiers,
	game.c.condition_types, 
	game.c.consequence_qualifiers,
	game.c.consequence_types
}
local current_category
local current_choices = { 1, 1, 1, 1 }
local proposing_player = 0
local current_votes = {}
local seconds_to_vote = 0

function start()
  print('started choosing a new rule')
  current_phase = PHASES.choosing_rule
	
	-- reset current category
	current_category = 1
	
	-- change the proposing player
	--proposing_player = proposing_player + 1
	--if proposing_player > 4 then proposing_player = 1 end
	proposing_player = 1
	
	seconds_to_vote = 5
	current_votes = { false, false, false }
end

game.actors.new_generic('voting_component', function ()

	local function sign(x)
		return x>0 and 1 or x<0 and -1 or 0
	end

  function update()			
		if current_phase == PHASES.none then return end
	
		local up = game.controls.button_pressed(proposing_player, 'up')
		local down = game.controls.button_pressed(proposing_player, 'down')				
		local left = game.controls.button_pressed(proposing_player, 'left')
		local right = game.controls.button_pressed(proposing_player, 'right')
		
		if current_phase == PHASES.choosing_rule then
			if game.controls.button_pressed(proposing_player, 'action') then
				current_phase = PHASES.voting
				return
			end
		
			if not first_update then
				current_category = current_category + (left and -1 or 0) + (right and 1 or 0)
				if current_category == 0 then current_category = 4 end
				if current_category == table.getn(categories)+1 then current_category = 1 end
				
				current_choices[current_category] = current_choices[current_category] + (up and -1 or 0) + (down and 1 or 0)
				if current_choices[current_category] == 0 then current_choices[current_category] = table.getn(categories[current_category]) end
				if current_choices[current_category] == table.getn(categories[current_category])+1 then current_choices[current_category] = 1 end
			else
				first_update = false
			end
		end
		
		if current_phase == PHASES.voting then
			if seconds_to_vote <= 0 then
				current_phase = PHASES.none
				-- TODO : take majority of votes and elect rule if > 50%
				game.rules.add_rule(current_choices[1], current_choices[2], current_choices[3], current_choices[4])
				game.action.resume()
				return
			else
				seconds_to_vote = seconds_to_vote - 1/60
			end
		end
  end
	
	local function draw_line(text)
		graphics.draw_text(game.resources.font, text)	
		gl.glTranslated(0, -10, 0)
  end	
	
	local function add_plural(word, qualifier)
		if qualifier ~= 'each' then return game.c.types_plural[word] end
		return word
	end	
	
	local function draw_rule(rule)		
		draw_line(string.format('%s %s %s %s',
			rule.condition_qualifier, add_plural(rule.condition_type, rule.condition_qualifier), rule.consequence_qualifier, rule.consequence_type))		
	end
	
  local function draw_choice(category)
		gl.glPushMatrix()
		
		local choices = categories[category]
		local current_choice = current_choices[category]
		
		gl.glTranslated(COLUMN_SPACING / 2, 0, 0)
		
		-- evaluate size of column
		local max_width = 0
		for _, choice in ipairs(choices) do
			choice = category == 2 and add_plural(choice, categories[1][current_choices[1]]) or choice
			max_width = math.max(max_width, game.resources.font_string_width(choice))
		end
		local total_height = table.getn(choices) * (8 + LINE_SPACING) -- where 10 is graphics.font_map_line_height(game.resources.font)
		
		-- highlight the back for selected category
		gl.glColor4d(0.5, 0.5, 0.5, 0.5)
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
				local choice = category == 2 and add_plural(choices[index], categories[1][current_choices[1]]) or choices[index]
			
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
			local choice = category == 2 and add_plural(choices[current_choice], categories[1][current_choices[1]]) or choices[current_choice]
			graphics.draw_text(game.resources.font, choice)
		end
		
		gl.glPopMatrix()
		gl.glTranslated(max_width + COLUMN_SPACING / 2, 0, 0)
  end
	
	local function draw_existing_rules()
		gl.glPushMatrix()
		gl.glScaled(2, 2, 2)
		draw_line('existing rules :')
		draw_line('----------------')
		gl.glColor3d(0.85, 0.85, 0.85)
		for _, rule in ipairs(game.rules.rules) do
			draw_rule(rule)
		end
		if table.getn(game.rules.rules) == 0 then draw_line('(none)') end
		gl.glColor3d(1, 1, 1)
		gl.glPopMatrix()
	end
	
	local function draw_quad()
		gl.glBegin(gl.GL_QUADS)
			gl.glVertex2d(0, 0)  
			gl.glVertex2d(0, -1)				
			gl.glVertex2d(1, -1) 
			gl.glVertex2d(1, 0) 
		gl.glEnd()
	end
	
	local function draw_voting_player(player)
		gl.glScaled(2, 2, 1)
		draw_line('player '.. player .. ' votes!')
		if current_phase == PHASES.voting then
			draw_line('yes / no')
		else
			draw_line('wait for the rule...')		
		end
	end	
	
	local function draw_proposing_player()
		gl.glScaled(2, 2, 1)
		if current_phase == PHASES.choosing_rule then
			draw_line('player '.. proposing_player .. ' proposes the rule!')
			for i = 1,4 do
				draw_choice(i)
			end			
		else
			-- fake rule so I can print it... ^_^
			local rule = {}
			rule.condition_qualifier = game.c.condition_qualifiers[current_choices[1]]
			rule.condition_type = game.c.condition_types[current_choices[2]]
			rule.consequence_qualifier = game.c.consequence_qualifiers[current_choices[3]]		
			rule.consequence_type = game.c.consequence_types[current_choices[4]]			
			draw_line('player '.. proposing_player .. ' has chosen this rule :')
			draw_rule(rule)
		end
	end
  
  function draw_gui()
		if current_phase == PHASES.none then return end
		
		local width = game.gui.width
		local height = game.gui.height
		
		-- split screen SIX ways!
		local safe_width = width - BOX_MARGIN * 4 - EXISTING_RULES_WIDTH
		local safe_height = height - BOX_MARGIN * 4 - INFO_BAR_HEIGHT
		gl.glColor4d(0.5, 0.5, 0.5, 0.5)
		-- existing rules
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN, height - BOX_MARGIN, 0)
			gl.glScaled(EXISTING_RULES_WIDTH, safe_height + BOX_MARGIN + INFO_BAR_HEIGHT + BOX_MARGIN, 1)
			draw_quad()		
		gl.glPopMatrix()
		-- info bar
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN, 0)
			gl.glScaled(safe_width + BOX_MARGIN, INFO_BAR_HEIGHT, 1)
			draw_quad()		
		gl.glPopMatrix()
		-- four compartments
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN, height - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN + safe_width / 2 + BOX_MARGIN, height - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN - INFO_BAR_HEIGHT - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN + safe_width / 2 + BOX_MARGIN, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN - INFO_BAR_HEIGHT - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glColor3d(1, 1, 1)
		
		-- draw the rule selection for the choosing player
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN * 2, height - BOX_MARGIN * 2, 0)
			if proposing_player == 1 then draw_proposing_player() else draw_voting_player(1) end
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN + safe_width / 2 + BOX_MARGIN * 2, height - BOX_MARGIN * 2, 0)
			if proposing_player == 2 then draw_proposing_player() else draw_voting_player(2) end
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN * 2, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN - INFO_BAR_HEIGHT - BOX_MARGIN * 2, 0)
			if proposing_player == 3 then draw_proposing_player() else draw_voting_player(3) end
		gl.glPopMatrix()
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN + safe_width / 2 + BOX_MARGIN * 2, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN - INFO_BAR_HEIGHT - BOX_MARGIN * 2, 0)
			if proposing_player == 4 then draw_proposing_player() else draw_voting_player(4) end
		gl.glPopMatrix()			
		
		-- draw the countdown
		if current_phase == PHASES.voting then
			gl.glPushMatrix()
				gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN * 2 + (safe_width + BOX_MARGIN) / 2, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN * 2.75, 0)
				gl.glScaled(2, 2, 1)
				local text = seconds_to_vote <= 0 and '' or math.ceil(seconds_to_vote) .. ' seconds left to vote!' -- prevent glitches
				local width = game.resources.font_string_width(text)
				gl.glTranslated(-width/2, 0, 0)
				draw_line(text)
			gl.glPopMatrix()
		end
		
		-- draw the existing rules
		gl.glPushMatrix()
		gl.glTranslated(BOX_MARGIN * 2, game.gui.height - BOX_MARGIN * 2, 0)
		draw_existing_rules()
		gl.glPopMatrix()
  end

end)
