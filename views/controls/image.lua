local Image = Controls.Control:extend()

function Image:new(o)
	self.image = o.image
	self.color = o.color or 4
	
	if self.image then
		if not (o.size and o.size.x or o.width ) then o.width  = self.image:getWidth () end
		if not (o.size and o.size.y or o.height) then o.height = self.image:getHeight() end
	end
	
	Image.super.new(self, o)
end

function Image:draw()
	-- self:clearRect()
	love.graphics.setColor(VieWS.PALETTE[self.color])
	love.graphics.draw(self.image)
end

return Image
