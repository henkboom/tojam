game.collision.add_collider(self, 'character', function (other, correction)
  other.player.attributes.teacup = other.player.attributes.teacup + 1
	self.dead = true
end)