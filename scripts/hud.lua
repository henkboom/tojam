local graphics = require 'dokidoki.graphics'
local gl = require 'gl'

local teacup = game.resources.sprites.pickup
local medal = game.resources.sprites.medal
local heart = game.resources.sprites.heart

local function draw_player_info(index, skip)
	gl.glPushMatrix()
		local text
		if skip ~= true then
			if index == 1 then gl.glColor3f(0.8, 0.8, 0.8)
			elseif index == 2 then gl.glColor3f(0.25, 0.25, 1)
			elseif index == 3 then gl.glColor3f(1, 0.25, 0.25)
			elseif index == 4 then gl.glColor3f(0.25, 1, 0.25)
			end
			
			text = 'player ' .. index .. ' :  '
			graphics.draw_text(game.resources.font, text)	
			gl.glTranslated(game.resources.font_string_width(text), 0, 0)
			gl.glColor3f(1, 1, 1)
		end
		gl.glPushMatrix()
			gl.glScaled(0.5, 0.5, 1)
			gl.glTranslated(0, -8, 0)
			teacup:draw()
		gl.glPopMatrix()
		gl.glTranslated(4, 0, 0)
		text = ' x ' .. game.actors.get('player')[index].player.attributes.teacup .. '   '
		graphics.draw_text(game.resources.font, text)	
		gl.glTranslated(game.resources.font_string_width(text), 0, 0)
		gl.glPushMatrix()
			gl.glScaled(0.5, 0.5, 1)
			gl.glTranslated(0, -8, 0)
			medal:draw()
		gl.glPopMatrix()
		gl.glTranslated(4, 0, 0)
		text = ' x ' .. game.actors.get('player')[index].player.attributes.point .. '   '
		graphics.draw_text(game.resources.font, text)	
		gl.glTranslated(game.resources.font_string_width(text), 0, 0)
		gl.glPushMatrix()
			gl.glScaled(0.5, 0.5, 1)
			gl.glTranslated(0, -8, 0)
			heart:draw()
		gl.glPopMatrix()
		gl.glTranslated(4, 0, 0)
		text = ' x ' .. game.actors.get('player')[index].player.attributes.health
		graphics.draw_text(game.resources.font, text)	
	gl.glPopMatrix()
	
	gl.glTranslated(0, -10, 0)
end

function draw_gui()
	if game.action.paused then
		gl.glPushMatrix()
			gl.glPushMatrix()
				gl.glTranslated(255+16, 590 - 230, 0)
				gl.glScaled(2, 2, 1)
				draw_player_info(1, true)
			gl.glPopMatrix()
			gl.glPushMatrix()
				gl.glTranslated(530+16, 590 - 230, 0)
				gl.glScaled(2, 2, 1)
				draw_player_info(2, true)
			gl.glPopMatrix()			
			gl.glPushMatrix()
				gl.glTranslated(255+16, 265 - 230, 0)
				gl.glScaled(2, 2, 1)
				draw_player_info(3, true)
			gl.glPopMatrix()
			gl.glPushMatrix()
				gl.glTranslated(530+16, 265 - 230, 0)
				gl.glScaled(2, 2, 1)
				draw_player_info(4, true)
			gl.glPopMatrix()			
		gl.glPopMatrix()	
	else
		gl.glPushMatrix()
			gl.glTranslated(10, 90, 0)
			gl.glScaled(2, 2, 1)

			draw_player_info(1)
			draw_player_info(2)
			draw_player_info(3)
			draw_player_info(4)
		gl.glPopMatrix()	
	end
end