condition_type = {"steps", "cups", "damage"}
condition_qualifier = {"each", "most", "least"}
consequence_type = {"steps", "cups", "damage", "victory"}
consequence_qualifier = {"add", "remove"}

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
    for _, v in ipairs(players) do
      if v[type] < least_count then
        least_count = v[type]
        least_player = v
      end
    end
    return { least_player }
  end
  
functions.add = function(targets, type)
    for _, target in ipairs(targets) do
      if type == "cups" or type == "steps" or type == "damage" then
        target[type] = target[type] + 1
      end
    end
  end
  
functions.remove = function(targets, type)
    for _, target in ipairs(targets) do
      if type == "cups" or type == "steps" or type == "damage" then
        target[type] = target[type] - 1
      end
    end
  end

function add_rule(type1, qual1, type2, qual2)
  local rule = {}
  rule.condition_type = condition_type[type1]
  rule.condition_qualifier = condition_qualifier[qual1]
  rule.consequence_type = consequence_type[type2]
  rule.consequence_qualifier = consequence_qualifier[qual2]
  rules[#rules+1] = rule
end

function register_event(player, type)
  for _, rule in ipairs(event_rules) do
    if rule.condition_qualifier == "each" and rule.condition_type == type then
      functions[rule.consequence_qualifier]({player}, rule.consequence_type)
    end
  end
end

function fire_round_rule(players, rule)
  if rule.condition_qualifier ~= "each" then
    local targets = functions[rule.condition_qualitifier](players, rule.condition_type)
    functions[rule.consequence_qualifier](targets, rule.consequence_type)
  end
end