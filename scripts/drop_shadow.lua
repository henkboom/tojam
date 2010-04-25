local gl = require 'gl'
local v2 = require 'dokidoki.v2'

local image = game.resources.textures.drop_shadow

local function frac(x)
	return x - math.floor(x)
end

local function draw_for_tile(tile, fraction)
	local height = game.level.get_height(tile.x+1, tile.y+1)
	if height == nil then return end
	
	local shadow_scale = math.min(math.max(0, (self.transform.height - height) / 64), 1) * 1 + 0.7
	
	gl.glColor4d(0, 0, 0, 0.7)

	gl.glPushMatrix()
	gl.glTranslated(tile.y * 16, height + 0.01, tile.x * 16)
	gl.glScaled(16, 1, 16)
	
	gl.glMatrixMode(gl.GL_TEXTURE)
	gl.glPushMatrix()
	gl.glTranslated(-(shadow_scale - 1) / 2, -(shadow_scale - 1) / 2, 1)
	gl.glScaled(shadow_scale, shadow_scale, 1)
	gl.glTranslated(-fraction.y, -fraction.x, 0)
	
	gl.glBegin(gl.GL_QUADS)
		gl.glTexCoord2d(0, 0); gl.glVertex3d(0, 0, 0)
		gl.glTexCoord2d(0, 1); gl.glVertex3d(0, 0, 1)
		gl.glTexCoord2d(1, 1); gl.glVertex3d(1, 0, 1)
		gl.glTexCoord2d(1, 0); gl.glVertex3d(1, 0, 0)
	gl.glEnd()
	
	gl.glPopMatrix()
	
	gl.glMatrixMode(gl.GL_MODELVIEW)
	gl.glPopMatrix()
	
	gl.glColor3d(1, 1, 1)
end

function draw()
	-- the player can be on 4 different tiles
	game.resources.textures.drop_shadow:enable()	
	gl.glTexParameterf(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
  gl.glTexParameterf(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP)
  gl.glTexParameterf(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP)	
	
	local pos = self.transform.pos
	local tile = pos / 16
	
	local iTile = v2(math.floor(tile.x), math.floor(tile.y))
	local fraction = tile - iTile - v2(0.5, 0.5)
	
	draw_for_tile(iTile + v2(-1, 0), v2(fraction.x + 1, fraction.y))
	draw_for_tile(iTile + v2(1, 0), v2(fraction.x - 1, fraction.y))
	draw_for_tile(iTile + v2(0, -1), v2(fraction.x, fraction.y + 1))
	draw_for_tile(iTile + v2(0, 1), v2(fraction.x, fraction.y - 1))
	draw_for_tile(iTile + v2(1, 1), v2(fraction.x - 1, fraction.y - 1))
	draw_for_tile(iTile + v2(-1, -1), v2(fraction.x + 1, fraction.y + 1))
	draw_for_tile(iTile, fraction)
	
	game.resources.textures.drop_shadow:disable()
end