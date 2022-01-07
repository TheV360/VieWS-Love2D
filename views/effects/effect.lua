local Effect = OptObject:extend()

function Effect:new(o)
	Effect.super.new(self, o)
	
	self.position = o.position or Point(o.x, o.y)
	
	self.life = -1
end

function Effect:draw()
	if self.life < 0 then return end
	
	love.graphics.setColor(VieWS.PALETTE[4])
	love.graphics.points(self.position:unpack())
end

return Effect
