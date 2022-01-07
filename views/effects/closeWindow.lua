local CloseWindow = Effects.Effect:extend()

CloseWindow.maxLife = 60

function CloseWindow:new(o)
	CloseWindow.super.new(self, o)
	
	self.size = o.size or Size(o.width or 8, o.height or 8)
	self.life = CloseWindow.maxLife
	self.fallDir = (math.random() > 0.5 and 1 or -1) * (1 + math.floor(math.random() * 10 + 0.5) / 10)
end

function CloseWindow:draw()
	local p = 1 - (self.life / CloseWindow.maxLife)
	
	love.graphics.push()
		local fall = Vec2(p * self.fallDir, math.sin(math.pi * p * 1.25) * -60)
		local pos = self.position + self.size / 2 + fall
		local scale = Vec2.lerp(self.size, Vec2(0), p)
		local scale2 = scale / 2
		love.graphics.translate(pos:unpack())
		love.graphics.rotate(p * p * self.fallDir * 4)
		love.graphics.setColor(VieWS.PALETTE[4])
		love.graphics.rectangle("fill", -scale2.x, -scale2.y, scale.x, scale.y)
		love.graphics.setColor(VieWS.PALETTE[1])
		love.graphics.rectangle("line", 0.5 - scale2.x, 0.5 - scale2.y, scale.x + 1, scale.y + 1)
	love.graphics.pop()
end

return CloseWindow
