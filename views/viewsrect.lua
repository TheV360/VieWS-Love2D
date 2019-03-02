-- A rectangle, but you can draw it.

local VieWSRect = OptObject:extend()

function VieWSRect:new(o)
	self.position = Point(
		o.x or (o.position and o.position.x) or 0,
		o.y or (o.position and o.position.y) or 0
	)
	self.size = Size(
		o.width  or (o.size and o.size.width ) or 1,
		o.height or (o.size and o.size.height) or 1
	)
end

function VieWSRect:update()
end

function VieWSRect:draw()
	love.graphics.rectangle(
		"fill",
		self.position.x,
		self.position.y,
		self.size.width,
		self.size.height
	)
end

return VieWSRect
