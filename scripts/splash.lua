local v2 = require 'dokidoki.v2'

assert(timer, 'missing timer argument')

self.billboard.color[4] = 0

local vel = 0.5

function update()
  timer = timer - 1
  self.billboard.color[4] = math.min(self.billboard.color[4] + 1/60, 1)

  self.transform.pos = self.transform.pos + v2(-vel, -vel)
  self.transform.height = self.transform.height + vel
  vel = vel * 0.97
  
  if timer <= 0 then
    if self.billboard.color[4] <= 0 then
      self.dead = true
      if when_dead then when_dead() end
    end
    self.billboard.color[4] = self.billboard.color[4] - 0.05
  end
end
