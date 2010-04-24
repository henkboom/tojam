local graphics = require 'dokidoki.graphics'

sprites = {
  character = graphics.sprite_from_image('sprites/character.png', nil, 'center')
}

font = require('dokidoki.default_font').load()

function font_string_width(text)
	local total_width = 0
	for c in text:gmatch"." do
    total_width = total_width + font[c].size[1]
	end
  return total_width
end