local OpenWindow = Effects.Effect:extend()

OpenWindow.maxLife = 15

function OpenWindow:new(o)
	OpenWindow.super.new(self, o)
	
	self.size = Size(o.width or 8, o.height or 8)
	
	self.life = OpenWindow.maxLife
end

function OpenWindow:draw()
	local p = 1 - (self.life / OpenWindow.maxLife)
	
	love.graphics.setColor(0, 0, 0, 1 - p)
	love.graphics.rectangle(
		"line",
		Util.lerp(self.position.x - 1, self.position.x - self.size.width  / 8, p),
		Util.lerp(self.position.y - 1, self.position.y - self.size.height / 8, p),
		Util.lerp(self.size.width  + 2, self.size.width  * 1.25, p),
		Util.lerp(self.size.height + 2, self.size.height * 1.25, p)
	)
end

return OpenWindow
