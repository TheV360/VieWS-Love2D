local Label = Controls.Control:extend()

function Label:new(o)
	self.text = o.text or "Label"
	self.color = o.color or 1
	
	o.size = o.size or Vec2(o.width or -1, o.height or -1)
	
	-- If width was left unspecified, figure it out from the given text.
	if o.size.x < 0 then
		o.size.x = font:getWidth(o.text)
		o.size.y = font:getHeight()
	end
	
	-- If width was given but height was left unspecified,
	-- wrap the text to fill the width, and figure out the height from that.
	if o.size.y < 0 then
		local wrapWidth, lines = font:getWrap(o.text, o.maxWidth or o.size.x)
		o.size.x = wrapWidth
		o.size.y = (lines and #lines or 1) * font:getHeight()
	end
	
	Label.super.new(self, o)
end

function Label:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[self.color])
	love.graphics.printf(self.text, 0, 0, self.size.x, "center")
end

return Label
