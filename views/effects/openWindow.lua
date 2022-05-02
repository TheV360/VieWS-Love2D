local OpenWindow = Effects.Effect:extend()

OpenWindow.maxLife = 1/6

function OpenWindow:new(o)
	OpenWindow.super.new(self, o)
	
	self.size = o.size or Size(o.width or 8, o.height or 8)
	
	self.life = OpenWindow.maxLife
end

function OpenWindow:draw()
	local p = 1 - (self.life / OpenWindow.maxLife)
	
	local pos = Vec2.lerp(self.position - 1, self.position - self.size / 8, p)
	local size = Vec2.lerp(self.size + 2, self.size * 5/4, p)
	
	love.graphics.setColor(VieWS.PALETTE[1], 1)
	love.graphics.rectangle("line", pos.x, pos.y, size.x, size.y)
end

return OpenWindow
