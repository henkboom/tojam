rules = {}

local functions = {}

functions.most = function(players, type)
    local most_count = -999999
    local most_player
    for _, v in ipairs(players) do
      if v[type] > most_count then
        most_count = v[type]
        most_player = v
      end
    end
    return { most_player }
  end
  
functions.least = function(players, type)
    local least_count = 999999
    local least_player
    for _, player in ipairs(players) do
      if player.character.attributes[type] < least_count then
        least_count = player.character.attributes[type]
        least_player = player
      end
    end
    return { least_player }
  end
  
functions.each = function(players, type)
  return players
end
  
functions.add = function(targets, type)
    for _, target in ipairs(targets) do
      target.character.attributes[type] = target.character.attributes[type] + 1
    end
  end
  
functions.remove = function(targets, type)
    for _, target in ipairs(targets) do
      target.character.attributes[type] = target.character.attributes[type] - 1
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
    if rule.condition_qualifier == "each" and rule.condition_type == type then
      fire_rule({player}, rule)
    end
  end
end

function fire_rule(players, rule)
  print('rule fired: '
        .. rule.condition_qualifier .. ' ' .. rule.condition_type .. ' ' 
        .. rule.consequence_qualifier .. ' ' .. rule.consequence_type)
  local targets = functions[rule.condition_qualifier](players, rule.condition_type)
  functions[rule.consequence_qualifier](targets, rule.consequence_type)
end
