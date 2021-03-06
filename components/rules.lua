rules = {}

local qualifier_functions = {}

qualifier_functions.most = function(players, type)
    local most_count = -math.huge
    local most_player
    for _, player in ipairs(players) do
      if player.player.attributes[type] > most_count then
        most_count = player.player.attributes[type]
        most_player = player
      end
    end
    return { most_player }
  end
  
qualifier_functions.least = function(players, type)
    local least_count = math.huge
    local least_player
    for _, player in ipairs(players) do
      if player.player.attributes[type] < least_count then
        least_count = player.player.attributes[type]
        least_player = player
      end
    end
    return { least_player }
  end
  
qualifier_functions.each = function(players, type)
  return players
end

qualifier_functions.adds = function(targets, type, quantity)
  local max = game.c.attr_ranges[type].max
  for _, target in ipairs(targets) do
    local value = target.player.attributes[type]

    local text
    if value < max then
      target.player.attributes[type] = math.min(max, value + quantity)
      text = '+' .. type
    else
      text = 'max ' .. type
    end
      target.player.queue_popup({'popup', text=text, color={0, 1, 0}})
    if type == "health" then
      target.billboard.flash({0, 1, 0})
    end
  end
end
  
qualifier_functions.removes = function(targets, type, quantity)
  local min = game.c.attr_ranges[type].min
  for _, target in ipairs(targets) do
    local value = target.player.attributes[type]

    local text
    if value > min then
      target.player.attributes[type] = math.max(min, value - quantity)
      text = '-' .. type
    else
      text = 'min ' .. type
    end
      target.player.queue_popup({'popup', text=text, color={1, 0, 0}})
    if type == "health" then
      target.billboard.flash({0, 1, 0})
    end
  end
end

function add_rule(qual1, type1, qual2, type2)
  local rule = {}
  rule.condition_type = game.c.condition_types[type1]
  rule.condition_qualifier = game.c.condition_qualifiers[qual1]
  rule.consequence_type = game.c.consequence_types[type2]
  rule.consequence_qualifier = game.c.consequence_qualifiers[qual2]
  rules[#rules+1] = rule
end

function register_event(player, type)
  for _, rule in ipairs(rules) do
    if game.c.event_qualifiers[rule.condition_qualifier] and rule.condition_type == type then
      fire_rule({player}, rule)
    end
  end
end

function end_round()
  local players = game.actors.get("player")
  for _, rule in ipairs(rules) do
    if game.c.round_qualifiers[rule.condition_qualifier] then
      fire_rule(players, rule)
    end
  end
end

function fire_rule(players, rule)
  print('rule fired: '
        .. rule.condition_qualifier .. ' ' .. rule.condition_type .. ' ' 
        .. rule.consequence_qualifier .. ' ' .. rule.consequence_type)
  local targets = qualifier_functions[rule.condition_qualifier](players, rule.condition_type)
  qualifier_functions[rule.consequence_qualifier](targets,
    rule.consequence_type, game.c.consequence_quantities[rule.condition_qualifier])
end

function check_victory()
  local players = game.actors.get("player")
  for _, player in ipairs(players) do
    if player.player.attributes["point"] >= 100 then
      game.actors.new(game.blueprints.victory_screen,
        {'victory_screen', player=player.player.number})
    end
  end
end
