function update()
  print(game.controls.get_direction(1))
  self.transform.pos = self.transform.pos + game.controls.get_direction(1)
end
