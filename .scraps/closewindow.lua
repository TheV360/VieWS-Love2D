
function CloseWindow:draw()
	local p = 1 - (self.life / CloseWindow.maxLife)
	local bottomDist = view.size.y - self.position.y
	
	love.graphics.push()
		local fall = Vec2(p * self.fallDir, math.sin(math.pi * p * 1.25) * -Util.clampLerp(20, bottomDist, p * p * 1.25))
		local pos = self.position + self.size / 2 + fall
		local scale = Vec2.lerp(self.size, Vec2(), p)
		local scale2 = scale / 2
		love.graphics.translate(pos:unpack())
		love.graphics.rotate(p * p * self.fallDir * 4)
		love.graphics.setColor(VieWS.PALETTE[4])
		love.graphics.rectangle("fill", -scale2.x, -scale2.y, scale.x, scale.y)
		love.graphics.setColor(VieWS.PALETTE[1])
		love.graphics.rectangle("line", 0.5 - scale2.x, 0.5 - scale2.y, 1 + scale.x, 1 + scale.y)
	love.graphics.pop()
end
