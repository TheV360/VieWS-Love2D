Image = Control:extend()

function Image:new(o)
	self.image = o.image
	self.color = o.color or {1, 1, 1, 1}
	
	if self.image then
		if not (o.size and o.size.width  or o.width ) then o.width  = self.image:getWidth () end
		if not (o.size and o.size.height or o.height) then o.height = self.image:getHeight() end
	end
	
	Image.super.new(self, o)
end

function Image:draw()
	love.graphics.setColor(self.color)
	self:clearRect()
	
	love.graphics.draw(self.image)
end

return Image
