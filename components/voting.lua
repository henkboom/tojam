-- voting.lua
-- controls the voting phase

local voting = false

function start()
  print('started voting')
  voting = true
end

game.actors.new_generic('voting_component', function ()

  function update()
    if voting then
      voting = false
      print('done voting')
      game.action.resume()
    end
  end

end)
