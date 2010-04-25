local gl = require 'gl'
local mixer = require 'mixer'
local stb_image = require 'stb_image'
local graphics = require 'dokidoki.graphics'
local mixer = require 'mixer'

sprites = {
  tojam = graphics.sprite_from_image('sprites/TOJam.png', nil, 'center'),
  no_fun = graphics.sprite_from_image('sprites/no_fun.png', nil, 'center'),
  instructions = graphics.sprite_from_image('sprites/instructions.png', nil, 'center'),
  title = graphics.sprite_from_image('sprites/title.png', nil, 'center'),
  credits = graphics.sprite_from_image('sprites/credits.png', nil, 'center'),
  
  enemy = graphics.sprite_from_image('sprites/monster.png', nil, 'center'),
  enemy_death = graphics.sprite_from_image('sprites/monster_death.png', nil, 'center'),
	pickup = graphics.sprite_from_image('sprites/teacup.png', nil, 'center'),
	heart = graphics.sprite_from_image('sprites/heart.png', nil, 'center'),
	medal = graphics.sprite_from_image('sprites/medal.png', nil, 'center')
}

player_sprites = {
	{ stand = graphics.sprite_from_image('sprites/player1_stand.png', nil, 'center'),
		attack = graphics.sprite_from_image('sprites/player1_attack.png', nil, 'center'),
		dead = graphics.sprite_from_image('sprites/player1_dead.png', nil, 'center') },
	{ stand = graphics.sprite_from_image('sprites/player2_stand.png', nil, 'center'),
		attack = graphics.sprite_from_image('sprites/player2_attack.png', nil, 'center'),
		dead = graphics.sprite_from_image('sprites/player2_dead.png', nil, 'center') },
	{ stand = graphics.sprite_from_image('sprites/player3_stand.png', nil, 'center'),
		attack = graphics.sprite_from_image('sprites/player3_attack.png', nil, 'center'),
		dead = graphics.sprite_from_image('sprites/player3_dead.png', nil, 'center') },		
	{ stand = graphics.sprite_from_image('sprites/player4_stand.png', nil, 'center'),
		attack = graphics.sprite_from_image('sprites/player4_attack.png', nil, 'center'),
		dead = graphics.sprite_from_image('sprites/player4_dead.png', nil, 'center') },				
}

sfx = {
  damage = mixer.load_wav('audio/damage.wav'),
  miss = mixer.load_wav('audio/miss.wav'),
  jump = mixer.load_wav('audio/jump.wav')
}

textures = {
  grass = graphics.texture_from_image('sprites/grass.png'),
  cliff = graphics.texture_from_image('sprites/cliff.png'),
	drop_shadow = graphics.texture_from_image('sprites/drop_shadow.png')
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

music = mixer.load_ogg('music/god_save_the_queen.ogg')
