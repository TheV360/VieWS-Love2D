local OpenWindow = Effects.Effect:extend()

OpenWindow.maxLife = 15

function OpenWindow:new(o)
	OpenWindow.super.new(self, o)
	
	self.size = Size(o.width or 8, o.height or 8)
	
	self.life = OpenWindow.maxLife
end

function OpenWindow:draw()
	local p = 1 - (self.life / OpenWindow.maxLife)
	
	local color = 1
	if p > 3/4 then color = 4
	elseif p > 1/2 then color = 3
	end
	
	love.graphics.setColor(VieWS.PALETTE[color], 1)
	love.graphics.rectangle(
		"line",
		Util.lerp(self.position.x - 1, self.position.x - self.size.x / 8, p),
		Util.lerp(self.position.y - 1, self.position.y - self.size.y / 8, p),
		Util.lerp(self.size.x + 2, self.size.x * (5/4), p),
		Util.lerp(self.size.y + 2, self.size.y * (5/4), p)
	)
end

return OpenWindow
