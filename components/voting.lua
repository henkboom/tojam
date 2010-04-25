local gl = require 'gl'
local graphics = require 'dokidoki.graphics'
local v2 = require 'dokidoki.v2'

-- voting.lua
-- controls the voting phase

local BOX_MARGIN = 5
local EXISTING_RULES_WIDTH = 240
local INFO_BAR_HEIGHT = 50

local COLUMN_SPACING = 7
local LINE_SPACING = 4
local LINE_HEIGHT = 7

local PHASES = { 
	none = 'none', 
	election_start = 'election_start', 
	choosing_rule = 'choosing_rule', 
	voting = 'voting', 
	election_results = 'election_results' 
}
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
local feedback_timer = 2
local seconds_to_vote = 0
local rule_passed = false

function start()
  print('started choosing a new rule')
  current_phase = PHASES.election_start
	
	-- reset current category
	current_category = 1
	
	-- change the proposing player
	proposing_player = proposing_player + 1
	if proposing_player > 4 then proposing_player = 1 end
	
	seconds_to_vote = 5
	current_votes = { false, false, false, false }
end

game.actors.new_generic('voting_component', function ()

	local function sign(x)
		return x>0 and 1 or x<0 and -1 or 0
	end

  function update()			
		if current_phase == PHASES.none then return end
		
		if current_phase == PHASES.choosing_rule then
			if game.controls.button_pressed(proposing_player, 'action') then
				current_phase = PHASES.voting
				current_votes[proposing_player] = false
				return
			end
				
			local up = game.controls.button_pressed(proposing_player, 'up')
			local down = game.controls.button_pressed(proposing_player, 'down')				
			local left = game.controls.button_pressed(proposing_player, 'left')
			local right = game.controls.button_pressed(proposing_player, 'right')
		
			current_category = current_category + (left and -1 or 0) + (right and 1 or 0)
			if current_category == 0 then current_category = 4 end
			if current_category == table.getn(categories)+1 then current_category = 1 end
			
			current_choices[current_category] = current_choices[current_category] + (up and -1 or 0) + (down and 1 or 0)
			if current_choices[current_category] == 0 then current_choices[current_category] = table.getn(categories[current_category]) end
			if current_choices[current_category] == table.getn(categories[current_category])+1 then current_choices[current_category] = 1 end
		end
		
		if current_phase == PHASES.voting then
			if seconds_to_vote <= 0 then
				current_phase = PHASES.election_results
				local count_yays = 0
				for i = 1,4 do count_yays = count_yays + (current_votes[i] and 1 or 0) end
				if count_yays >= 2 then
					game.rules.add_rule(current_choices[1], current_choices[2], current_choices[3], current_choices[4])
					rule_passed = true
				else
					rule_passed = false
				end
				return
			else
				seconds_to_vote = seconds_to_vote - 1/60
			end
			
			-- do the selection stuff for voting players
			for i = 1,4 do
				if i ~= proposing_player then
					local up = game.controls.button_pressed(i, 'up')
					local down = game.controls.button_pressed(i, 'down')
					
					if up then current_votes[i] = false
					elseif down then current_votes[i] = true
					end
				end
			end
		end
		
		if current_phase == PHASES.election_start then
			if feedback_timer <= 0 then
				current_phase = PHASES.choosing_rule
				feedback_timer = 2
				return
			else
				feedback_timer = feedback_timer - 1/60
			end
		end
		
		if current_phase == PHASES.election_results then
			if feedback_timer <= 0 then
				current_phase = PHASES.none
				feedback_timer = 2
				game.action.resume()
				return
			else
				feedback_timer = feedback_timer - 1/60
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
			rule.condition_qualifier, add_plural(rule.condition_type, rule.condition_qualifier), rule.consequence_qualifier, add_plural(rule.consequence_type, rule.consequence_qualifier)))		
	end
	
  local function draw_choice(category)
		gl.glPushMatrix()
		
		local choices = categories[category]
		local current_choice = current_choices[category]
		
		gl.glTranslated(COLUMN_SPACING / 2, 0, 0)
		
		-- evaluate size of column
		local max_width = 0
		for _, choice in ipairs(choices) do
			if category == 2 then
				choice = add_plural(choice, categories[1][current_choices[1]])
			elseif category == 4 then 
				choice = add_plural(choice, categories[3][current_choices[3]])
			end
			max_width = math.max(max_width, game.resources.font_string_width(choice))
		end
		local total_height = table.getn(choices) * (8 + LINE_SPACING) -- where 10 is graphics.font_map_line_height(game.resources.font)
		
		-- highlight the back for selected category
		gl.glColor4d(0, 0, 0, 0.5)
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
				if category == 2 then
					choice = add_plural(choice, categories[1][current_choices[1]])
				elseif category == 4 then 
					choice = add_plural(choice, categories[3][current_choices[3]])
				end
			
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
			local choice = choices[current_choice]
			if category == 2 then
				choice = add_plural(choice, categories[1][current_choices[1]])
			elseif category == 4 then 
				choice = add_plural(choice, categories[3][current_choices[3]])
			end			
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
	
	local function draw_voting_choice(player)
		if current_votes[player] == false then
			gl.glPushMatrix()
				gl.glScaled(game.resources.font_string_width('no'), 10, 1)
				draw_quad()
			gl.glPopMatrix()
			gl.glColor3d(0, 0, 0)
		end
		draw_line('no')
		gl.glColor3d(1, 1, 1)
		
		if current_votes[player] == true then
			gl.glPushMatrix()
				gl.glScaled(game.resources.font_string_width('yes'), 10, 1)
				draw_quad()
			gl.glPopMatrix()
			gl.glColor3d(0, 0, 0)
		end			
		draw_line('yes')
		gl.glColor3d(1, 1, 1)
	end
	
	local function draw_voting_player(player)
		gl.glScaled(2, 2, 1)
		local title = ''
		if current_phase == PHASES.voting then
			draw_line('player '.. player .. ' is voting!')
			draw_voting_choice(player)
		elseif current_phase == PHASES.election_start then			
			draw_line('player '.. player .. ' votes!')
		elseif current_phase == PHASES.choosing_rule then
			draw_line('player '.. player .. ' votes!')
			draw_line('(wait for the proposal...)')		
		elseif current_phase == PHASES.election_results then
			draw_line('player '.. player .. ' has voted!')
		end
	end	
	
	local function draw_proposing_player()
		gl.glScaled(2, 2, 1)
		
		if (current_phase == PHASES.election_start) or (current_phase == PHASES.choosing_rule) then
			draw_line('player '.. proposing_player .. ' proposes the rule!')
		end
		
		if current_phase == PHASES.choosing_rule then
			for i = 1,4 do
				draw_choice(i)
			end			
		elseif (current_phase == PHASES.voting) or (current_phase == PHASES.election_results) then
			-- fake rule so I can print it... ^_^
			local rule = {}
			rule.condition_qualifier = game.c.condition_qualifiers[current_choices[1]]
			rule.condition_type = game.c.condition_types[current_choices[2]]
			rule.consequence_qualifier = game.c.consequence_qualifiers[current_choices[3]]		
			rule.consequence_type = game.c.consequence_types[current_choices[4]]			
			draw_line('player '.. proposing_player .. ' has chosen this rule :')
			draw_rule(rule)
		end
		
		if current_phases == PHASES.election_results then
			draw_line('player ' .. proposing_player .. (rule_passed and  ' passed the rule!' or ' failed to pass the rule.'))
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
		gl.glColor4d(0.5, 0.5, 0.5, proposing_player == 1 and 0.75 or 0.5)
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN, height - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glColor4d(0.5, 0.5, 0.5, proposing_player == 2 and 0.75 or 0.5)
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN + safe_width / 2 + BOX_MARGIN, height - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glColor4d(0.5, 0.5, 0.5, proposing_player == 3 and 0.75 or 0.5)
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN - INFO_BAR_HEIGHT - BOX_MARGIN, 0)
			gl.glScaled(safe_width / 2, safe_height / 2, 1)
			draw_quad()
		gl.glPopMatrix()
		gl.glColor4d(0.5, 0.5, 0.5, proposing_player == 4 and 0.75 or 0.5)
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
		
		-- draw the infobar content
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN + EXISTING_RULES_WIDTH + BOX_MARGIN * 2 + (safe_width + BOX_MARGIN) / 2, height - BOX_MARGIN - safe_height / 2 - BOX_MARGIN * 3.75, 0)
			gl.glScaled(3, 3, 1)
			
			local text = ''
			if current_phase == PHASES.election_start then text = 'election time again, gentlemen!'
			elseif current_phase == PHASES.choosing_rule then text = 'a new rule is being proposed...'
			elseif current_phase == PHASES.voting then text = seconds_to_vote <= 0 and '' or math.ceil(seconds_to_vote) .. ' seconds left to vote!' -- prevent glitches
			elseif current_phase == PHASES.election_results then text = rule_passed and 'new rule was elected!' or 'new rule was rejected...'
			end
			
			local width = game.resources.font_string_width(text)
			gl.glTranslated(-width/2, 0, 0)
			draw_line(text)
		gl.glPopMatrix()
		
		-- draw the existing rules
		gl.glPushMatrix()
			gl.glTranslated(BOX_MARGIN * 2, game.gui.height - BOX_MARGIN * 2, 0)
			draw_existing_rules()
		gl.glPopMatrix()
  end

end)
