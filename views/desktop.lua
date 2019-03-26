-- The desktop! contains icons, except when it doesn't

local Desktop = OptObject:extend()

function Desktop:new(o)
	self.parent = o.parent
end

function Desktop:update()
end

function Desktop:draw()
	love.graphics.setColor(0.25, 0.25, 0.25)
	love.graphics.rectangle("fill", 0, 0, self.parent.size.width, self.parent.size.height)
end

return Desktop
