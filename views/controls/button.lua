local Button = Controls.Control:extend()

function Button:new(o)
	self.text = o.text or "Button"
	self.color = o.color or {0, 0, 0, 1}
	
	if not (o.size and o.size.width  or o.width ) then o.width  = view.font:getWidth (o.text) + 4 end
	if not (o.size and o.size.height or o.height) then o.height = view.font:getHeight(o.text) + 4 end
	
	Button.super.new(self, o)
end

function Button:draw()
	self:clearRect()
	
	love.graphics.setColor(self.color)
	if self.hover then
		self:drawRect("fill")
		
		-- TODO: use proper theme colors, not hard-coded garbage
		
		love.graphics.setColor(0.85, 0.8, 0.8)
		love.graphics.print(
			self.text,
			math.ceil((self.size.width  - view.font:getWidth (self.text)) / 2),
			math.ceil((self.size.height - view.font:getHeight(         )) / 2)
		)
	else
		self:drawRect("line")
		
		love.graphics.print(
			self.text,
			math.ceil((self.size.width  - view.font:getWidth (self.text)) / 2),
			math.ceil((self.size.height - view.font:getHeight(         )) / 2)
		)
	end
end

return Button
