Effect = OptObject:extend()

function Effect:new(o)
	Effect.super.new(self, o)
	
	self.position = Point(o.x or 0, o.y or 0)
	
	self.life = -1
end

function Effect:draw()
	if self.life < 0 then return end
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.points(self.position.x, self.position.y)
end

return Effect
