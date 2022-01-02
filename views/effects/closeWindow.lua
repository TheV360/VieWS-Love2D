local CloseWindow = Effects.Effect:extend()

CloseWindow.maxLife = 15

function CloseWindow:new(o)
	CloseWindow.super.new(self, o)
	
	self.size = Size(o.width or 8, o.height or 8)
	
	self.life = CloseWindow.maxLife
end

function CloseWindow:draw()
	local p = 1 - (self.life / CloseWindow.maxLife)
	
	love.graphics.setColor(VieWS.PALETTE[1])
	love.graphics.rectangle(
		"line",
		Util.lerp(self.position.x, self.position.x + self.size.x / 2, p),
		Util.lerp(self.position.y, self.position.y + self.size.y / 2, p),
		Util.lerp(self.size.x, 0, p),
		Util.lerp(self.size.y, 0, p)
	)
end

return CloseWindow
