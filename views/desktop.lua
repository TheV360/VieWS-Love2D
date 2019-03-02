-- The desktop! contains icons, except when it doesn't

local Desktop = VieWSRect:extend()

function Desktop:new(o)
	Desktop.super.new(self, o)
end

function Desktop:draw()
	love.graphics.setColor(0.25, 0.25, 0.25)
	Desktop.super.draw(self)
end

return Desktop
