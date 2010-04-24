assert(source, 'missing source argument')
assert(offset, 'missing offset argument')

local frame_passed = false

function update()
  if frame_passed then
    self.dead = true
    if not hit then
      game.resources.sfx["miss"]:play(0.2)
    end
  else
    frame_passed = true
  end
end
