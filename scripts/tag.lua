assert(tags, 'missing tags argument')

for _,v in ipairs(tags) do
  self.tags[v] = true
end
