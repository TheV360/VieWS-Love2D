local CloseWindow = Effects.Effect:extend()

CloseWindow.maxLife = 120

function CloseWindow:new(o)
	CloseWindow.super.new(self, o)
	
	self.size = Size(o.width or 8, o.height or 8)
	self.fallDir = (math.random() > 0.5 and 1 or -1) * (1 + math.floor(math.random() * 10 + 0.5) / 10)
	
	self.life = CloseWindow.maxLife
end

function CloseWindow:draw()
	local p = 1 - (self.life / CloseWindow.maxLife)
	
	love.graphics.setColor(VieWS.PALETTE[Util.round(Util.lerp(4, 1, p))])
	love.graphics.push()
		local fall = Vec2(p * self.fallDir, math.sin(math.pi * p * 1.25) * -60)
		local pos = self.position + self.size / 2 + fall
		local scale = Vec2.lerp(self.size, Vec2(0), p)
		love.graphics.translate(pos:unpack())
		love.graphics.rotate(p * p * self.fallDir * 4)
		love.graphics.scale(scale:unpack())
		love.graphics.rectangle("fill", -0.5, -0.5, 1, 1)
	love.graphics.pop()
end

return CloseWindow
