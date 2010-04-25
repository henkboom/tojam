game.collision.add_collider(self, 'player', function (other, correction)
  other.player.attributes.teacup = other.player.attributes.teacup + 1
	self.dead = true
end)