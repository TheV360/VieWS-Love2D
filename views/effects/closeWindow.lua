CloseWindow = Effect:extend()

CloseWindow.maxLife = 15

function CloseWindow:new(o)
	CloseWindow.super.new(self, o)
	
	self.size = Size(o.width or 8, o.height or 8)
	
	self.life = CloseWindow.maxLife
end

function CloseWindow:draw()
	local p = 1 - (self.life / CloseWindow.maxLife)
	
	love.graphics.setColor(0, 0, 0, 1 - p)
	love.graphics.rectangle(
		"fill",
		Util.lerp(self.position.x + 1, self.position.x + self.size.width  / 4, p),
		Util.lerp(self.position.y + 1, self.position.y + self.size.height / 4, p),
		Util.lerp(self.size.width  - 2, self.size.width  / 2, p),
		Util.lerp(self.size.height - 2, self.size.height / 2, p)
	)
	love.graphics.rectangle(
		"line",
		Util.lerp(self.position.x, self.position.x + self.size.width  / 8, p),
		Util.lerp(self.position.y, self.position.y + self.size.height / 8, p),
		Util.lerp(self.size.width , self.size.width  * 0.75, p),
		Util.lerp(self.size.height, self.size.height * 0.75, p)
	)
end

return CloseWindow
