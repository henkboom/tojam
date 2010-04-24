local gl = require 'gl'
local mixer = require 'mixer'
local stb_image = require 'stb_image'
local graphics = require 'dokidoki.graphics'

sprites = {
  character = graphics.sprite_from_image('sprites/character.png', nil, 'center')
}

sfx = {
  damage = mixer.load_wav('audio/damage.wav'),
  miss = mixer.load_wav('audio/miss.wav')
}

textures = {
  grass = graphics.texture_from_image('sprites/grass.png'),
  cliff = graphics.texture_from_image('sprites/cliff.png')
}

for _, t in pairs(textures) do
  t:enable()
  gl.glTexParameterf(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_REPEAT)
  gl.glTexParameterf(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_REPEAT)
  t:disable()
end

font = require('dokidoki.default_font').load()

function font_string_width(text)
	local total_width = 0
	for c in text:gmatch"." do
    total_width = total_width + font[c].size[1]
	end
  return total_width
end

level = stb_image.load('sprites/level.png', 1)
