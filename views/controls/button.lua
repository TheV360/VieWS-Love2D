local Button = Controls.Control:extend()

function Button:new(o)
	self.text = o.text or "Button"
	self.color = o.color or 1
	
	if not (o.size and o.size.width  or o.width ) then o.width  = view.font:getWidth (o.text) + 4 end
	if not (o.size and o.size.height or o.height) then o.height = view.font:getHeight(o.text) + 4 end
	
	Button.super.new(self, o)
end

function Button:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[self.color])
	if self.hover then
		self:drawRect("fill")
		love.graphics.setColor(VieWS.PALETTE[4])
	else
		self:drawRect("line")
	end
	
	love.graphics.print(
		self.text,
		math.ceil((self.size.width  - view.font:getWidth (self.text)) / 2),
		math.ceil((self.size.height - view.font:getHeight(         )) / 2)
	)
end

function Button:mouse(m)
	view:switchCursor("hand")
end

return Button
