assert(timer, 'missing timer argument')

function update()
  timer = timer - 1
  
  if timer <= 0 then
    self.dead = true
    if when_dead then when_dead() end
  end
end