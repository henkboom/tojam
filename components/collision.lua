local gl = require 'gl'
local collision = require 'dokidoki.collision'
local v2 = require 'dokidoki.v2'

-- keeps track of actors which should be notified of collisions with certain
-- tags
-- {tag -> {{actor, callback}...}}
local collider_index = {}

function add_collider(actor, tag, callback)
  collider_index[tag] = collider_index[tag] or {}
  table.insert(collider_index[tag], {actor, callback})
end

game.actors.new_generic('collision', function ()
  function collision_check()
    -- utility function for using the collision functions
    local function set_body(body, actor)
      body.pos = actor.transform.pos
      body.facing = actor.transform.facing
      body.poly = actor.collider.poly
    end
    local body1 = {}
    local body2 = {}

    -- for every colliding tag
    for tag, colliders in pairs(collider_index) do
      local tagged_actors = game.actors.get(tag)
      -- for every collider registered for that tag
      for _, collider in ipairs(colliders) do
        local colliding_actor, callback = unpack(collider)
        if not colliding_actor.dead then
          set_body(body1, colliding_actor)
          -- for every actor with the tag
          for _, tagged_actor in ipairs(tagged_actors) do
            if colliding_actor ~= tagged_actor and not tagged_actor.dead then
              set_body(body2, tagged_actor)

              -- collision check!
              local correction = collision.collide(body1, body2)
              if correction then
                callback(tagged_actor, correction)
                -- if the colliding actor died they shouldn't collide anymore
                if colliding_actor.dead then
                  break
                end
              end
            end
          end
        end
      end
    end

    -- remove dead colliders
    for tag, colliders in ipairs(collider_index) do
      collider_index[tag] = base.ifilter(colliders, function (collider)
        return not collider[1].dead
      end)
      -- nillify empty arrays
      if #collider_index[tag] == 0 then
        collider_index[tag] = nil
      end
    end
  end
end)
