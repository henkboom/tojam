game.collision.add_collider(self, 'player', function (other, correction)
  other.player.attributes.teacup = other.player.attributes.teacup + 1
	game.rules.register_event(self, "teacup")
	self.dead = true
end)