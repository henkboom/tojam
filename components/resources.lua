local graphics = require 'dokidoki.graphics'
local mixer = require 'mixer'

sprites = {
  character = graphics.sprite_from_image('sprites/character.png', nil, 'center'),
  enemy = graphics.sprite_from_image('sprites/monster.png', nil, 'center')
}

sfx = {
  damage = mixer.load_wav('audio/damage.wav'),
  miss = mixer.load_wav('audio/miss.wav')
}

font = require('dokidoki.default_font').load()

function font_string_width(text)
	local total_width = 0
	for c in text:gmatch"." do
    total_width = total_width + font[c].size[1]
	end
  return total_width
end