condition_type = {"steps", "cups", "damage"}
condition_qualifier = {"each", "most", "least"}
consequence_type = {"steps", "cups", "damage", "victory"}
consequence_qualifier = {"add", "remove"}

rules = {}

function add_rule(type1, qual1, type2, qual2)
  local rule = {}
  rule.condition_type = type1
  rule.condition_qualifier = qual1
  rule.consequence_type = type2
  rule.consequence_qualifier = qual2
  rules[#rules+1] = rule
end


function fire_rule(rule)
  local target = condition_qualifier[rule.condition_qualitifier](rule.condition_type)
  
  if consequence_qualifier == "add" then
    add(target, rule.consequence_type)
  else
    remove(target, rule.consequence_type)
  end
end

function most(type, players)
  local most_count = -999
  local most_player
  
  for _, v in ipairs(players) do
    if v[type] > most_count then
      most_count = v[type]
      most_player = v
    end
  end
  
  return most_player
end