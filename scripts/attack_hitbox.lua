assert(player, 'missing player argument')
assert(offset, 'missing offset argument')

local frame_passed = false

function update()
  if frame_passed then
    self.dead = true
  else
    frame_passed = true
  end
end
